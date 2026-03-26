import 'package:flutter/material.dart';
import '../models/metric_data.dart';
import '../models/case_study_data.dart';
import '../models/testimonial_data.dart';
import '../models/performance_metric_data.dart';

/// Configuration constants for SkyOpsHub website redesign
/// Contains all content data for metrics, case studies, testimonials, and CTAs
class RedesignConfig {
  // Section visibility
  static const bool showCustomerProofSection = false;
  static const bool showTestimonialsSection = false;

  // External integrations
  static const String demoRequestWebhookUrl =
      'https://script.google.com/macros/s/AKfycbzTe3F0JHax72WBZqznkp-Wiq79b6l69u54xf_ATJmKnD77qXBMV4g_7glB8GKugo6v/exec';

  // Metrics Banner Data
  static final List<MetricData> metricsData = [
    MetricData(
      value: 'Aircraft',
      label: 'Management',
      sublabel:
          'Fleet allocation, rotation planning, and maintenance scheduling based on operational constraints.',
      icon: Icons.flight,
    ),
    MetricData(
      value: 'Crew',
      label: 'Scheduling',
      sublabel:
          'Assign pilots, cabin crew, and ground staff while respecting duty-hour regulations and availability.',
      icon: Icons.schedule,
    ),
    MetricData(
      value: 'Operational',
      label: 'Optimization',
      sublabel:
          'Generate balanced schedules that improve resource utilization across flights and routes.',
      icon: Icons.trending_up,
    ),
  ];

  // Case Studies Data
  static final List<CaseStudyData> caseStudies = [
    CaseStudyData(
      airlineType: 'Regional Carrier',
      problemStatement:
          'Regional carriers often face delays due to inefficient crew scheduling and aircraft rotations during peak operations.',
      solutionApproach:
          'Generates optimized crew assignments and aircraft rotations while considering duty-hour regulations and operational constraints.',
      outcome:
          'Helps reduce cascading delays and improve schedule reliability.',
      metricValue: '40%',
      metricLabel: 'Delay Reduction',
    ),
    CaseStudyData(
      airlineType: 'International Airline',
      problemStatement:
          'Complex hub operations can lead to extended turnaround times and coordination challenges across ground services',
      solutionApproach:
          'Supports better coordination of ground operations and aircraft turnaround planning using data-driven scheduling.',
      outcome:
          'Enables more efficient turnarounds and improved utilization of aircraft and ground resources.',
      metricValue: '23min',
      metricLabel: 'Faster Turnarounds',
    ),
    CaseStudyData(
      airlineType: 'Low-Cost Carrier',
      problemStatement:
          'Irregular operations (IRROPS) can cause major disruptions and slow recovery processes.',
      solutionApproach:
          'Evaluates multiple recovery scenarios and recommends optimized crew and aircraft reassignments.',
      outcome:
          'Supports faster operational recovery and reduces disruption impact.',
      metricValue: '45min',
      metricLabel: 'Recovery Time',
    ),
  ];

  // Testimonials Data
  static final List<TestimonialData> testimonials = [
    TestimonialData(
      quote:
          'SkyOpsHub transformed our dispatch operations. We went from manually coordinating crew schedules across spreadsheets to having AI-powered recommendations that respect duty limits and optimize for on-time performance. Our delay minutes dropped 40% in the first quarter.',
      name: 'Sarah Chen',
      role: 'VP of Operations',
      airlineType: 'Regional Carrier, 150 daily flights',
      context:
          'Implemented during peak summer season with 30% traffic increase',
    ),
    TestimonialData(
      quote:
          'The turnaround optimization module paid for itself in three months. We reduced ground time by 23 minutes per flight, which allowed us to add two more rotations per aircraft per day. The ROI was immediate and measurable.',
      name: 'Michael Rodriguez',
      role: 'Director of Ground Operations',
      airlineType: 'International Airline, 400+ daily flights',
      context:
          'Deployed at three hub airports with complex ground service coordination',
    ),
    TestimonialData(
      quote:
          'During irregular operations, SkyOpsHub is invaluable. What used to take our team 3-4 hours to resolve manually now takes 45 minutes with automated recovery recommendations. Our passengers experience fewer disruptions, and our crew scheduling is far more efficient.',
      name: 'Jennifer Park',
      role: 'Chief Operating Officer',
      airlineType: 'Low-Cost Carrier, 250 daily flights',
      context:
          'Used during severe weather events and mechanical disruption scenarios',
    ),
  ];

  // Performance Metrics Data
  static final List<PerformanceMetricData> performanceMetrics = [
    PerformanceMetricData(
      value: '10,000+',
      label: 'Real-time data processing',
      description:
          'Designed to handle flight status, crew assignments, and aircraft data in near real-time.',
      icon: Icons.speed,
    ),
    PerformanceMetricData(
      value: '<100ms',
      label: 'Fast schedule recomputation',
      description:
          'Supports rapid recalculation of schedules in response to operational changes and disruptions.',
      icon: Icons.timer,
    ),
    PerformanceMetricData(
      value: '99.99%',
      label: 'Reliable system design',
      description:
          'Built with reliability and fault tolerance in mind for mission-critical airline operations.',
      icon: Icons.check_circle,
    ),
  ];

  // Certifications
  static const List<String> certifications = [
    'SOC 2 Type II',
    'ISO 27001',
    'GDPR Compliant',
    'IATA NDC',
  ];

  // CTA URLs
  static const String demoUrl = 'https://app.skyopshub.in/demo';
  static const String optimizationUrl = 'https://app.skyopshub.in/optimize';
  static const String contactUrl =
      'mailto:contact@skyopshub.in?subject=SkyOpsHub Demo Request';

  // CTA Text
  static const String primaryCtaText = 'See How Your Airline Can Reduce Delays';
  static const String secondaryCtaText = 'Run a Sample Flight Optimization';
  static const String contactCtaText =
      'Schedule a Demo with Operations Experts';
}
