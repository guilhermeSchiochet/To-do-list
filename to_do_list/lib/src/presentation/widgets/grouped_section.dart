import 'package:flutter/material.dart';
import 'package:to_do_list/src/config/themes/app_colors.dart';

/// Um bloco de opções no estilo das listas agrupadas do iOS: um título
/// pequeno em maiúsculas sobre um cartão arredondado.
/// A grouped-list section in the iOS style.
class GroupedSection extends StatelessWidget {
  /// Título acima do cartão. Quando ausente, o cartão aparece sozinho.
  final String? title;

  /// Linhas do bloco, separadas por divisórias automaticamente.
  final List<Widget> children;

  const GroupedSection({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 7),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: colors.secondaryLabel,
              ),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: ColoredBox(
            color: colors.surface,
            child: Column(children: _separated(colors)),
          ),
        ),
      ],
    );
  }

  /// Insere divisórias entre as linhas, recuadas para alinhar com o texto.
  List<Widget> _separated(AppColors colors) {
    final result = <Widget>[];

    for (var i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(Divider(
          height: 0.5,
          thickness: 0.5,
          indent: 56,
          color: colors.separator,
        ));
      }
    }

    return result;
  }
}

/// Texto à direita de uma [GroupedRow].
/// Text on the right side of a [GroupedRow].
class GroupedValue extends StatelessWidget {
  final String text;

  /// Destaca o valor em azul, para quando ele é o que o usuário escolheu.
  final bool emphasized;

  const GroupedValue(this.text, {super.key, this.emphasized = false});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end,
        style: TextStyle(
          fontSize: 17,
          color: emphasized ? AppPalette.primary : context.colors.secondaryLabel,
          fontWeight: emphasized ? FontWeight.w500 : FontWeight.w400,
        ),
      ),
    );
  }
}

/// Valor seguido da seta que indica "isto abre outra tela".
/// A value followed by the chevron meaning "this opens something".
class GroupedDisclosure extends StatelessWidget {
  final String value;
  final bool emphasized;

  const GroupedDisclosure(this.value, {super.key, this.emphasized = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GroupedValue(value, emphasized: emphasized),
        const SizedBox(width: 4),
        Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: context.colors.tertiaryLabel,
        ),
      ],
    );
  }
}

/// Valor opcional com um botão para apagá-lo, usado em data e hora.
/// An optional value with a button to clear it, used by date and time.
class GroupedClearableValue extends StatelessWidget {
  /// Valor atual. Nulo mostra o [placeholder] e esconde o botão de limpar.
  final String? value;

  final String placeholder;
  final VoidCallback onClear;

  const GroupedClearableValue({
    super.key,
    required this.value,
    required this.placeholder,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GroupedValue(value ?? placeholder, emphasized: value != null),
        if (value == null)
          const SizedBox(width: 4)
        else
          IconButton(
            onPressed: onClear,
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.only(left: 6),
            constraints: const BoxConstraints(),
            icon: Icon(
              Icons.cancel_rounded,
              size: 18,
              color: context.colors.tertiaryLabel,
            ),
          ),
      ],
    );
  }
}

/// Uma linha dentro de um [GroupedSection]: ícone colorido, título e um
/// conteúdo à direita.
class GroupedRow extends StatelessWidget {
  final IconData icon;

  /// Cor de fundo do quadrado do ícone.
  final Color iconColor;

  final String title;

  /// Widget exibido à direita: um valor, um switch, uma seta.
  final Widget? trailing;

  final VoidCallback? onTap;

  const GroupedRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(icon, color: Colors.white, size: 17),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 17, color: colors.label),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
