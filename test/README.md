# Tests unitarios

Esta carpeta contiene tests **sin dispositivo ni HTTP real**: se usan **dobles** (mocks) para el datasource y el repositorio.

## Cómo ejecutar

Desde la raíz del proyecto:

```bash
flutter test
```

Para un solo archivo:

```bash
flutter test test/data/recommendation_response_test.dart
```

## Dependencias de test

Definidas en `pubspec.yaml` bajo `dev_dependencies`:

- **`mocktail`** — definición de mocks y `when` / `verify`.
- **`bloc_test`** — `blocTest` para aserciones sobre secuencias de estados del `CalculatorCubit`.

## Organización

| Ruta | Qué se prueba |
|------|----------------|
| `test/data/recommendation_response_test.dart` | Parseo de `RecommendationResponse.fromJson` (tasa como string o número; error si falta el campo). |
| `test/data/calculator_dto_test.dart` | `CalculatorDto.toQueryParameters` (`type`, IDs de moneda, `amount`, `amountCurrencyId`). |
| `test/data/conversion_repository_impl_test.dart` | Fórmulas de conversión y propagación de `HttpError` con datasource mockeado. |
| `test/presentation/calculator_cubit_test.dart` | Emisión de `CalculatorLoading` → `Loaded` o `Error` con repositorio mockeado. |

## Convenciones

- **`registerFallbackValue(CalculatorDto.mock())`** en `setUpAll` cuando se usa `any()` con métodos que reciben `CalculatorDto` (requisito de mocktail).
- Los tests de Cubit importan `calculator_cubit.dart`, que incluye los estados vía `part`.

## Qué no cubre esta suite

- Widget tests (`WidgetTester`), tests de integración end-to-end y llamadas reales al API. Pueden agregarse en PRs posteriores.
