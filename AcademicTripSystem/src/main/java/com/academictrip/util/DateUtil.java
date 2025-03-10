package com.academictrip.util;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

/**
 * Utility class for handling date conversions and formatting across the application
 */
public class DateUtil {

    private static final DateTimeFormatter DEFAULT_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    /**
     * Safely extract a LocalDate from a ResultSet
     * @param rs The ResultSet to extract from
     * @param columnName The column name
     * @return A LocalDate or null if the column was null
     * @throws SQLException if a database error occurs
     */
    public static LocalDate getLocalDate(ResultSet rs, String columnName) throws SQLException {
        Date sqlDate = rs.getDate(columnName);
        if (rs.wasNull() || sqlDate == null) {
            return null;
        }
        return sqlDate.toLocalDate();
    }

    /**
     * Safely get a LocalDate from a ResultSet by column index
     * @param rs The ResultSet containing the date
     * @param columnIndex The index of the column containing the date
     * @return LocalDate object or null if date is null
     * @throws SQLException if a database error occurs
     */
    public static LocalDate getLocalDate(ResultSet rs, int columnIndex) throws SQLException {
        java.sql.Date sqlDate = rs.getDate(columnIndex);
        return (sqlDate != null) ? sqlDate.toLocalDate() : null;
    }

    /**
     * Format a LocalDate using the default formatter (yyyy-MM-dd)
     * @param date The date to format
     * @return A formatted string or null if the input was null
     */
    public static String formatDate(LocalDate date) {
        return date != null ? date.format(DEFAULT_FORMATTER) : null;
    }

    /**
     * Format a LocalDate using a custom formatter
     * @param date The date to format
     * @param formatter The formatter to use
     * @return A formatted string or null if the input was null
     */
    public static String formatDate(LocalDate date, DateTimeFormatter formatter) {
        return date != null ? date.format(formatter) : null;
    }

    /**
     * Convert java.sql.Date to LocalDate safely
     * @param sqlDate The SQL date to convert
     * @return A LocalDate or null if the input was null
     */
    public static LocalDate toLocalDate(Date sqlDate) {
        return sqlDate != null ? sqlDate.toLocalDate() : null;
    }

    /**
     * Convert LocalDate to java.sql.Date safely
     * @param localDate The LocalDate to convert
     * @return A SQL Date or null if the input was null
     */
    public static Date toSqlDate(LocalDate localDate) {
        return localDate != null ? Date.valueOf(localDate) : null;
    }

    /**
     * Parse a date string using the default formatter (yyyy-MM-dd)
     * @param dateStr The date string to parse
     * @return A LocalDate or null if the input was null or empty
     * @throws DateTimeParseException if the date string is invalid
     */
    public static LocalDate parseDate(String dateStr) throws DateTimeParseException {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        return LocalDate.parse(dateStr, DEFAULT_FORMATTER);
    }

    /**
     * Parse a date string using a custom pattern
     * @param dateStr The date string to parse
     * @param pattern The pattern to use for parsing
     * @return A LocalDate or null if the input was null or empty
     * @throws DateTimeParseException if the date string is invalid
     */
    public static LocalDate parseDate(String dateStr, String pattern) throws DateTimeParseException {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern);
        return LocalDate.parse(dateStr, formatter);
    }
}
