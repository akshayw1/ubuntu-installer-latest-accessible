        Expanded(
          child: FocusTraversalGroup(
            child: Semantics(
              // Semantic label for screen readers
              label: "Language selection - Use arrow keys to navigate on this list. "
                     "Press Home to go to the first item, End to go to the last item. on this",
              excludeSemantics: false,
              child: Focus(
                focusNode: listFocusNode,