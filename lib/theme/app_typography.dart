import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  // LEVEL 1 — THE HOOK (60% weight in hierarchy)
  // Large, bold headers — establishes brand voice
  static TextStyle h1({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: color,
  );

  static TextStyle h2({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: color,
  );

  // LEVEL 2 — THE CONTEXT (30% weight)
  // Subheaders, body text — high legibility
  static TextStyle h3({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color,
  );

  static TextStyle body({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: color,
  );

  static TextStyle bodyMedium({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: color,
  );

  // LEVEL 3 — THE DETAIL (10% weight)
  // Captions, labels, micro-copy
  static TextStyle caption({Color? color}) => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: color,
  );

  static TextStyle label({Color? color}) => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.2,
    color: color,
  );

  // SPECIAL — Large stat numbers (steps, calories, weight)
  static TextStyle statLarge({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 42,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    color: color,
  );

  static TextStyle statMedium({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    color: color,
  );
}
