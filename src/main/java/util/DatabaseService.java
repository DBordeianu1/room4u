package util;

import java.sql.*;

public class DatabaseService {

    private Connection connection;

    public DatabaseService() {
        try {
            connection = DBConnection.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    //login stuff

    public int getHotelId(String role, Connection connection, int id_number, String id_type) throws SQLException {
        if (role.equals("MANAGER")) {
            PreparedStatement ps = connection.prepareStatement("SELECT hotel_id FROM employee WHERE id_number = ? AND id_type = ?");
            ps.setInt(1, id_number);
            ps.setString(2, id_type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("hotel_id");
            }
            return -1;
        }
        else { //changed bc i litearlly forgot works_at was a relation here
            PreparedStatement ps = connection.prepareStatement(
                    "SELECT hotel_id FROM works_at WHERE id_number = ? AND id_type = ?"
            );
            ps.setInt(1, id_number);
            ps.setString(2, id_type);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("hotel_id");
            }

            return -1;
        }
    }

    public boolean loginCustomer(int idNumber, String idType) {
        try {
            String query = "SELECT * FROM customer WHERE id_number = ? AND id_type = ?";
            PreparedStatement ps = connection.prepareStatement(query);

            ps.setInt(1, idNumber);
            ps.setString(2, idType);

            ResultSet rs = ps.executeQuery();

            if (!rs.next()) { //insert just the id
                return false;
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return true;
    }

    public boolean loginEmployee(int idNumber, String idType) {
        try {
            String query = "SELECT * FROM employee_role WHERE id_number = ? AND id_type = ?";
            PreparedStatement ps = connection.prepareStatement(query);

            ps.setInt(1, idNumber);
            ps.setString(2, idType);

            ResultSet rs = ps.executeQuery();

            if (!rs.next()) { //insert just the id
                return false;
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return true;
    }

    //login functions

    public boolean checkExists(int id_number, String id_type) throws SQLException {
        try {
            String sql = "SELECT 1 FROM person WHERE id_number = ? AND id_type = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id_number);
            ps.setString(2, id_type);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return true;
            } else {
                return false;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean checkCustomer(int id_number, String id_type) throws SQLException {
        try {
            String sql = "SELECT 1 FROM customer WHERE id_number = ? AND id_type = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id_number);
            ps.setString(2, id_type);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return true;
            } else {
                return false;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    //should work with the trigger now
    public void addNewUser(String role, int idNumber, String idType, String firstName, String middleName, String lastName, int streetNumber, String streetName, String city, String province, String postalCode, String country, Integer hotelId) throws SQLException {

        //insert into person first
        String insertPersonSQL = "INSERT INTO person (id_number, id_type, first_name, middle_name, last_name, " + "street_number, street_name, city, state_province, zip_postal_code, country) " + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        PreparedStatement psPerson = connection.prepareStatement(insertPersonSQL);
        psPerson.setInt(1, idNumber);
        psPerson.setString(2, idType);
        psPerson.setString(3, firstName);
        psPerson.setString(4, middleName);
        psPerson.setString(5, lastName);
        psPerson.setInt(6, streetNumber);
        psPerson.setString(7, streetName);
        psPerson.setString(8, city);
        psPerson.setString(9, province);
        psPerson.setString(10, postalCode);
        psPerson.setString(11, country);
        psPerson.executeUpdate();

        //role-specific insertions

        //customer (note: the registration attribute was changed to reflect time of registration and not time of booking)
        if (role.equals("CUSTOMER")) {
            String insertCustomerSQL = "INSERT INTO customer (id_number, id_type, date_of_registration) VALUES (?, ?, NOW())";

            PreparedStatement customer = connection.prepareStatement(insertCustomerSQL);
            customer.setInt(1, idNumber);
            customer.setString(2, idType);
            customer.executeUpdate();
            return;
        }

        //employee
        //manager is also here because managers are employees (see er diagram)
        if (role.equals("EMPLOYEE") || role.equals("MANAGER")) {

            //insert into employeee first
            //logic to ONLY ADD HOTEL ID IF MANAGER
            if (role.equals("MANAGER")){
                String ps = "INSERT INTO employee (id_number, id_type, hotel_id) VALUES (?, ?, ?)";
                PreparedStatement manager = connection.prepareStatement(ps);
                manager.setInt(1, idNumber);
                manager.setString(2, idType);
                manager.setInt(3, hotelId);
                manager.executeUpdate();
            }
            else{
                String ps2 = "INSERT INTO employee (id_number, id_type) VALUES (?, ?)";
                PreparedStatement employee = connection.prepareStatement(ps2);
                employee.setInt(1, idNumber);
                employee.setString(2, idType);
                employee.executeUpdate();

                String ps3 = "INSERT INTO works_at (id_number, id_type, hotel_id) VALUES (?, ?, ?)";
                PreparedStatement worksat = connection.prepareStatement(ps3);
                worksat.setInt(1, idNumber);
                worksat.setString(2, idType);
                worksat.setInt(3, hotelId);
                worksat.executeUpdate();
            }

            //to store role
            String insertRoleSQL = "INSERT INTO employee_role (id_number, id_type, employee_role) VALUES (?, ?, ?)";

            PreparedStatement psRole = connection.prepareStatement(insertRoleSQL);
            psRole.setInt(1, idNumber);
            psRole.setString(2, idType);
            psRole.setString(3, role.toLowerCase()); //can be anything but with this function it's always gonna be employee or manager lol
            psRole.executeUpdate();
        }
    }

    public boolean removeEmployee(int idNumber, String idType) {
        try {
            String sql = "DELETE FROM employee WHERE id_number=? AND id_type=?";
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, idNumber);
            ps.setString(2, idType);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean removeCustomer(int idNumber, String idType) {
        try { //very similar to employee
            String sql = "DELETE FROM person WHERE id_number = ? AND id_type = ?";
            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, idNumber);
            ps.setString(2, idType);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean validateID(String idtype, String id){
        boolean valid = true;

        if (idtype.equals("sin")){
            if (!id.matches("\\d{9}") || id.charAt(0) == '0') { //9 digit syntax or if it starts with 0 bc db complains about sins starting w 0 LOL
                valid = false;
            } else { //this is the luhn algorithm
                //start @ last number, multiply even numbers by 2
                //if multiplied number >= 10, add digits together
                //add to sum
                int sum = 0;
                for (int i = id.length() - 1; i >= 0; i--) {
                    int digit = Character.getNumericValue(id.charAt(i));
                    if ((i + 1) % 2 == 0) {
                        digit *= 2;
                        if (digit > 9){
                            String digitStringed = String.valueOf(digit);
                            digit = 0;
                            for (int j = 0; j < digitStringed.length(); j++){
                                digit += Character.getNumericValue(digitStringed.charAt(j));
                            }
                        }
                    }
                    sum += digit;
                }
                if (!(sum % 10 == 0)){
                    valid = false;
                }
            }
        }
        else{
            if (!id.matches("\\d{9}")) {
                valid = false;
            } else {
                String areacode = id.substring(0, 3);
                String group = id.substring(3, 5);
                String serialnum = id.substring(5, 9);

                if (areacode.equals("000") || areacode.equals("666") || areacode.charAt(0) == '9') valid = false;
                if (group.equals("00")) valid = false;
                if (serialnum.equals("0000")) valid = false;
            }
        }
        return valid;
    }
}

