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
            String query = "SELECT * FROM employee WHERE id_number = ? AND id_type = ?";
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

    public void addNewUser(String role, int idNumber, String idType, String firstName, String middleName, String lastName, int streetNumber, String streetName, String city, String province, String postalCode, String country, Integer hotelId
    ) throws SQLException {

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
            String insertEmployeeSQL = "INSERT INTO employee (id_number, id_type, hotel_id) VALUES (?, ?, ?)";

            PreparedStatement employee = connection.prepareStatement(insertEmployeeSQL);
            employee.setInt(1, idNumber);
            employee.setString(2, idType);
            employee.setInt(3, hotelId);
            employee.executeUpdate();

            //to store role
            String insertRoleSQL = "INSERT INTO employee_role (id_number, id_type, employee_role) VALUES (?, ?, ?)";

            PreparedStatement psRole = connection.prepareStatement(insertRoleSQL);
            psRole.setInt(1, idNumber);
            psRole.setString(2, idType);
            psRole.setString(3, role.toLowerCase()); //can be anything
            psRole.executeUpdate();

            //for MANAGERS only
            if (role.equals("MANAGER")) {
                String insertManagerSQL = "INSERT INTO manager (id_number, id_type) VALUES (?, ?)";

                PreparedStatement manager = connection.prepareStatement(insertManagerSQL);
                manager.setInt(1, idNumber);
                manager.setString(2, idType);
                manager.executeUpdate();
            }
        }
    }

    public boolean removeEmployee(int idNumber, String idType) {
        try {
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
}

