package com.aivision.today.today

import java.text.SimpleDateFormat
import java.util.Date

class Convertor {

    companion object {

        private val sdfTime = SimpleDateFormat("hh:mm")
        private val sdfDate = SimpleDateFormat("dd/M/yyyy")

        fun getTime(): String {
            return sdfTime.format(Date())
        }

        fun getDate(): String {
            return sdfDate.format(Date())
        }

        fun bytesIntoHumanReadable(bytes: Long): String? {
            val kilobyte: Long = 1024
            val megabyte = kilobyte * 1024
            val gigabyte = megabyte * 1024
            val terabyte = gigabyte * 1024
            return if (bytes >= 0 && bytes < kilobyte) {
                "$bytes B"
            } else if (bytes >= kilobyte && bytes < megabyte) {
                (bytes / kilobyte).toString() + " KB"
            } else if (bytes >= megabyte && bytes < gigabyte) {
                (bytes / megabyte).toString() + " MB"
            } else if (bytes >= gigabyte && bytes < terabyte) {
                (bytes / gigabyte).toString() + " GB"
            } else if (bytes >= terabyte) {
                (bytes / terabyte).toString() + " TB"
            } else {
                "$bytes Bytes"
            }
        }
    }
}