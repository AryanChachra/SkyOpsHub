import 'package:flutter/material.dart';
import '../../utils/responsive_breakpoints.dart';

/// Enhanced technology stack section with interactive elements and detailed information
class TechStackSection extends StatefulWidget {
  const TechStackSection({super.key});

  @override
  State<TechStackSection> createState() => _TechStackSectionState();
}

class _TechStackSectionState extends State<TechStackSection>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late List<Animation<double>> _itemAnimations;
  
  final List<TechStackItem> _techItems = [
    TechStackItem(
      name: 'Flutter Web',
      category: 'Frontend Excellence',
      description: 'Lightning-fast, responsive web applications built with Google\'s cutting-edge UI toolkit. '
          'Delivers native performance across all devices with a single codebase.',
      icon: Icons.web,
      color: Colors.blue,
      features: ['Cross-platform compatibility', 'Hot reload development', 'Native performance', '60fps animations'],
    ),
    TechStackItem(
      name: 'FastAPI',
      category: 'Backend Powerhouse',
      description: 'High-performance Python backends with automatic API documentation and type safety. '
          'Handles millions of requests with enterprise-grade reliability and security.',
      icon: Icons.dns,
      color: Colors.green,
      features: ['Auto API docs', 'Type safety', 'High performance', 'Async support'],
    ),
    TechStackItem(
      name: 'AI & ML Engines',
      category: 'Intelligence Core',
      description: 'Advanced machine learning algorithms powered by TensorFlow and PyTorch. '
          'Predictive analytics, optimization algorithms, and real-time decision making.',
      icon: Icons.psychology,
      color: Colors.purple,
      features: ['Predictive analytics', 'Real-time optimization', 'Neural networks', 'Deep learning'],
    ),
    TechStackItem(
      name: 'Cloud Infrastructure',
      category: 'Scalable Foundation',
      description: 'Enterprise-grade cloud architecture with auto-scaling, load balancing, and global CDN. '
          'Deployed across multiple regions for maximum reliability and performance.',
      icon: Icons.cloud,
      color: Colors.orange,
      features: ['Auto-scaling', 'Global CDN', 'Load balancing', '99.9% uptime'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _itemAnimations = List.generate(_techItems.length, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _staggerController,
        curve: Interval(
          index * 0.2,
          0.8 + (index * 0.05),
          curve: Curves.easeOutCubic,
        ),
      ));
    });
    
    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withOpacity(0.8),
          ],
        ),
      ),
      padding: ResponsiveBreakpoints.getResponsivePadding(context),
      child: ResponsiveContainer(
        child: Column(
          children: [
            _buildSectionHeader(context),
            const SizedBox(height: 48),
            _buildTechGrid(context),
            const SizedBox(height: 40),
            _buildArchitectureOverview(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Column(
      children: [
        // Animated badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo,
                Colors.purple,
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.architecture,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'ENTERPRISE ARCHITECTURE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        Text(
          'Built on Industry-Leading Technology',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: Theme.of(context).textTheme.headlineLarge?.color,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 16),
        
        Container(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            'Our technology stack represents the pinnacle of modern software engineering. '
            'Every component is carefully selected for performance, scalability, and reliability. '
            'This is the foundation that powers the world\'s most advanced airline operations platform.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              height: 1.6,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTechGrid(BuildContext context) {
    return ResponsiveWidget(
      mobile: _buildMobileGrid(context),
      desktop: _buildDesktopGrid(context),
    );
  }

  Widget _buildDesktopGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 2.0, // Reduced from 1.2 to make cards more compact
      ),
      itemCount: _techItems.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _itemAnimations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - _itemAnimations[index].value)),
              child: Opacity(
                opacity: _itemAnimations[index].value,
                child: _TechCard(item: _techItems[index]),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMobileGrid(BuildContext context) {
    return Column(
      children: _techItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        
        return AnimatedBuilder(
          animation: _itemAnimations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - _itemAnimations[index].value)),
              child: Opacity(
                opacity: _itemAnimations[index].value,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _TechCard(item: item),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildArchitectureOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.security,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Enterprise Security & Compliance',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.headlineSmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'SOC 2 Type II certified • GDPR compliant • End-to-end encryption • '
            'Multi-factor authentication • Role-based access control • '
            'Continuous security monitoring • Regular penetration testing',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class TechStackItem {
  final String name;
  final String category;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> features;

  TechStackItem({
    required this.name,
    required this.category,
    required this.description,
    required this.icon,
    required this.color,
    required this.features,
  });
}

class _TechCard extends StatefulWidget {
  final TechStackItem item;

  const _TechCard({required this.item});

  @override
  State<_TechCard> createState() => _TechCardState();
}

class _TechCardState extends State<_TechCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onHover(true),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                minWidth: 200,
                minHeight: 180,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: widget.item.color.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20), // Reduced from 24
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Added to make column size to content
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10), // Reduced from 12
                          decoration: BoxDecoration(
                            color: widget.item.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10), // Reduced from 12
                          ),
                          child: Icon(
                            widget.item.icon,
                            color: widget.item.color,
                            size: 20, // Reduced from 24
                          ),
                        ),
                        const SizedBox(width: 12), // Reduced from 16
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.item.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith( // Changed from titleLarge
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).textTheme.titleMedium?.color,
                                ),
                              ),
                              Text(
                                widget.item.category,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: widget.item.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 12), // Reduced from 16
                    
                    // Description
                    Text(
                      widget.item.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith( // Changed from bodyMedium
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        height: 1.4, // Reduced from 1.5
                      ),
                    ),
                    
                    const SizedBox(height: 12), // Reduced from 16
                    
                    // Features
                    Wrap(
                      spacing: 6, // Reduced from 8
                      runSpacing: 6, // Reduced from 8
                      children: widget.item.features.map((feature) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), // Reduced padding
                          decoration: BoxDecoration(
                            color: widget.item.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10), // Reduced from 12
                          ),
                          child: Text(
                            feature,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: widget.item.color,
                              fontWeight: FontWeight.w500,
                              fontSize: 11, // Made smaller
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}