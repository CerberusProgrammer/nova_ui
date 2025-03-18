import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nova_ui/components/theme/nova_theme_provider.dart';
import 'package:nova_ui/components/effects/nova_animation_style.dart';

/// A retro-futuristic cyber node network visualization
class NovaCyberNode extends StatefulWidget {
  /// Width of the component
  final double width;

  /// Height of the component
  final double height;

  /// Primary color (uses theme accent if null)
  final Color? nodeColor;

  /// Secondary color for connections (uses theme primary if null)
  final Color? connectionColor;

  /// Animation style controlling intensity
  final NovaAnimationStyle animationStyle;

  /// Animation speed multiplier (1.0 = normal)
  final double animationSpeed;

  /// Glow intensity (0.0 to 1.0)
  final double glowIntensity;

  /// Number of nodes in the network
  final int nodeCount;

  /// Whether to show grid in the background
  final bool showGrid;

  const NovaCyberNode({
    super.key,
    this.width = 300.0,
    this.height = 200.0,
    this.nodeColor,
    this.connectionColor,
    this.animationStyle = NovaAnimationStyle.standard,
    this.animationSpeed = 1.0,
    this.glowIntensity = 0.7,
    this.nodeCount = 12,
    this.showGrid = true,
  });

  @override
  State<NovaCyberNode> createState() => _NovaCyberNodeState();
}

class _NovaCyberNodeState extends State<NovaCyberNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_NetworkNode> _nodes;
  late List<_NetworkConnection> _connections;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (8000 / widget.animationSpeed).round()),
    );
    _controller.repeat();
    _generateNetwork();
  }

  void _generateNetwork() {
    // Generate nodes
    _nodes = List.generate(
      widget.nodeCount,
      (index) => _NetworkNode(
        position: Offset(
          _random.nextDouble() * 0.8 + 0.1,
          _random.nextDouble() * 0.8 + 0.1,
        ),
        size: 3.0 + _random.nextDouble() * 6.0,
        importance: _random.nextDouble(),
        pulsePhase: _random.nextDouble(),
        pulseSpeed: 0.5 + _random.nextDouble(),
      ),
    );

    // Generate connections between nodes
    _connections = [];
    for (int i = 0; i < _nodes.length; i++) {
      // Find 2-4 connections for each node
      final connectionCount = 2 + _random.nextInt(3);
      final possibleTargets =
          List.generate(_nodes.length, (index) => index)
            ..remove(i)
            ..shuffle();

      for (
        int j = 0;
        j < math.min(connectionCount, possibleTargets.length);
        j++
      ) {
        final targetIndex = possibleTargets[j];

        // Check if connection already exists
        final connectionExists = _connections.any(
          (c) =>
              (c.startNodeIndex == i && c.endNodeIndex == targetIndex) ||
              (c.startNodeIndex == targetIndex && c.endNodeIndex == i),
        );

        if (!connectionExists) {
          _connections.add(
            _NetworkConnection(
              startNodeIndex: i,
              endNodeIndex: targetIndex,
              strength: 0.3 + _random.nextDouble() * 0.7,
              pulseSpeed: 0.5 + _random.nextDouble(),
              pulsePhase: _random.nextDouble(),
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.novaTheme;
    final nodeColor = widget.nodeColor ?? theme.accent;
    final connectionColor = widget.connectionColor ?? theme.primary;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: nodeColor.withOpacity(0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: nodeColor.withOpacity(0.2 * widget.glowIntensity),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _CyberNodePainter(
              nodes: _nodes,
              connections: _connections,
              nodeColor: nodeColor,
              connectionColor: connectionColor,
              glowIntensity: widget.glowIntensity,
              animationValue: _controller.value,
              showGrid: widget.showGrid,
              animationStyle: widget.animationStyle,
            ),
          );
        },
      ),
    );
  }
}

class _NetworkNode {
  final Offset position;
  final double size;
  final double importance;
  final double pulsePhase;
  final double pulseSpeed;

  _NetworkNode({
    required this.position,
    required this.size,
    required this.importance,
    required this.pulsePhase,
    required this.pulseSpeed,
  });
}

class _NetworkConnection {
  final int startNodeIndex;
  final int endNodeIndex;
  final double strength;
  final double pulseSpeed;
  final double pulsePhase;

  _NetworkConnection({
    required this.startNodeIndex,
    required this.endNodeIndex,
    required this.strength,
    required this.pulseSpeed,
    required this.pulsePhase,
  });
}

class _CyberNodePainter extends CustomPainter {
  final List<_NetworkNode> nodes;
  final List<_NetworkConnection> connections;
  final Color nodeColor;
  final Color connectionColor;
  final double glowIntensity;
  final double animationValue;
  final bool showGrid;
  final NovaAnimationStyle animationStyle;

  _CyberNodePainter({
    required this.nodes,
    required this.connections,
    required this.nodeColor,
    required this.connectionColor,
    required this.glowIntensity,
    required this.animationValue,
    required this.showGrid,
    required this.animationStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      _drawGrid(canvas, size);
    }

    _drawConnections(canvas, size);
    _drawNodes(canvas, size);
    _drawDataPackets(canvas, size);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint =
        Paint()
          ..color = nodeColor.withOpacity(0.1)
          ..strokeWidth = 0.5;

    // Draw horizontal grid lines
    for (int i = 0; i <= 10; i++) {
      final y = size.height * (i / 10);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw vertical grid lines
    for (int i = 0; i <= 10; i++) {
      final x = size.width * (i / 10);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
  }

  void _drawConnections(Canvas canvas, Size size) {
    for (final connection in connections) {
      final startNode = nodes[connection.startNodeIndex];
      final endNode = nodes[connection.endNodeIndex];

      final startPoint = Offset(
        startNode.position.dx * size.width,
        startNode.position.dy * size.height,
      );

      final endPoint = Offset(
        endNode.position.dx * size.width,
        endNode.position.dy * size.height,
      );

      // Draw connection line
      final linePaint =
          Paint()
            ..color = connectionColor.withOpacity(connection.strength * 0.6)
            ..strokeWidth = 1.0;

      canvas.drawLine(startPoint, endPoint, linePaint);

      // Draw line glow
      if (glowIntensity > 0) {
        canvas.drawLine(
          startPoint,
          endPoint,
          Paint()
            ..color = connectionColor.withOpacity(
              connection.strength * 0.3 * glowIntensity,
            )
            ..strokeWidth = 3.0
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
        );
      }
    }
  }

  void _drawNodes(Canvas canvas, Size size) {
    for (final node in nodes) {
      final nodePos = Offset(
        node.position.dx * size.width,
        node.position.dy * size.height,
      );

      // Calculate pulse effect
      final phase = (animationValue + node.pulsePhase) % 1.0;
      final pulseEffect =
          math.sin(phase * math.pi * 2 * node.pulseSpeed) * 0.3 + 0.7;

      // Node glow
      if (glowIntensity > 0) {
        canvas.drawCircle(
          nodePos,
          node.size * 2 * pulseEffect,
          Paint()
            ..color = nodeColor.withOpacity(
              node.importance * 0.5 * glowIntensity,
            )
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
        );
      }

      // Main node
      canvas.drawCircle(
        nodePos,
        node.size * pulseEffect,
        Paint()..color = nodeColor.withOpacity(0.8 + node.importance * 0.2),
      );

      // Node center
      canvas.drawCircle(
        nodePos,
        node.size * 0.3,
        Paint()..color = Colors.white.withOpacity(0.8),
      );
    }
  }

  void _drawDataPackets(Canvas canvas, Size size) {
    final packetSize = 3.0;
    final animationMultiplier =
        animationStyle == NovaAnimationStyle.dramatic
            ? 1.5
            : animationStyle == NovaAnimationStyle.subtle
            ? 0.7
            : 1.0;

    for (final connection in connections) {
      final startNode = nodes[connection.startNodeIndex];
      final endNode = nodes[connection.endNodeIndex];

      final startPoint = Offset(
        startNode.position.dx * size.width,
        startNode.position.dy * size.height,
      );

      final endPoint = Offset(
        endNode.position.dx * size.width,
        endNode.position.dy * size.height,
      );

      // Calculate packet position along the connection line
      final packetProgress =
          ((animationValue * animationMultiplier) + connection.pulsePhase) %
          1.0;
      final packetPos = Offset(
        startPoint.dx + (endPoint.dx - startPoint.dx) * packetProgress,
        startPoint.dy + (endPoint.dy - startPoint.dy) * packetProgress,
      );

      // Draw packet glow
      if (glowIntensity > 0) {
        canvas.drawCircle(
          packetPos,
          packetSize * 2.5,
          Paint()
            ..color = nodeColor.withOpacity(0.6 * glowIntensity)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        );
      }

      // Draw packet
      canvas.drawCircle(packetPos, packetSize, Paint()..color = nodeColor);
    }
  }

  @override
  bool shouldRepaint(covariant _CyberNodePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
