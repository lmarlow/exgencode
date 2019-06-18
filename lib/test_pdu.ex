defmodule Exgencode.TestPdu do
  @moduledoc false
  # This is an internal testing file - it is been build due to protocol consolidation

  require Exgencode
  import Exgencode

  defpdu MsgSubSection, someField: [default: 15, size: 8]

  defpdu PzTestMsg,
    testField: [default: 1, size: 12],
    otherTestField: [size: 24],
    subSection: [default: %MsgSubSection{}, type: :subrecord],
    constField: [default: 10, size: 28, type: :constant]

  defpdu CustomEncodeMsg,
    randomField: [size: 8],
    customField: [
      encode: fn _ -> <<6::size(8)>> end,
      decode: fn pdu, <<_::size(8), rest::bitstring>> ->
        {Map.replace!(pdu, :customField, 6), rest}
      end
    ]

  defpdu VersionedMsg,
    oldField: [default: 10, size: 16],
    newerField: [size: 8, version: ">= 2.0.0"],
    evenNewerField: [
      size: 8,
      version: ">= 2.1.0",
      encode: fn val -> <<val * 2::size(8)>> end,
      decode: fn pdu, <<val::size(8), rest::bitstring>> ->
        {struct(pdu, %{evenNewerField: div(val, 2)}), rest}
      end
    ]

  defpdu EndianMsg,
    bigField: [default: 15, size: 32, endianness: :big],
    smallField: [default: 15, size: 32, endianness: :little]

  defpdu FloatMsg,
    floatField: [size: 32, type: :float],
    littleFloatField: [size: 64, type: :float, endianness: :little]

  defpdu BinaryMsg,
    someHeader: [size: 8, default: 10],
    binaryField: [size: 16, type: :binary]

  defpdu StringMsg,
    someHeader: [size: 8, default: 10],
    stringField: [size: 16, type: :string]

  ### PDUs for doctest

  defpdu CustomPdu,
    normalField: [size: 16, default: 3],
    customField: [
      encode: fn val -> <<val * 2::size(16)>> end,
      decode: fn pdu, <<val::size(16)>> -> {struct(pdu, %{customField: div(val, 2)}), <<>>} end
    ]

  defpdu PduWithConstant, aConstantField: [size: 16, default: 10, type: :constant]

  defpdu SubPdu, someField: [size: 16, default: 1]

  defpdu TopPdu,
    aField: [size: 24],
    subPdu: [type: :subrecord, default: %SubPdu{}]

  defpdu VirtualPdu,
    real_field: [size: 16],
    virtual_field: [type: :virtual]
end
