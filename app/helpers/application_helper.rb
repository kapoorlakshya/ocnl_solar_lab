module ApplicationHelper

	def color_by_module(m)

    # Module colors
    clr_pv1 = '#1F3473'
    clr_pv2 = '#825534'
    clr_pv3 = '#D93250'
    clr_pv4 = '#6A9AD9'
    clr_pv5 = '#D94625'
    clr_pv6 = '#00A388'

    case m
    when "M421101006AJB"
      return clr_pv1
    when "M431101063AJA"
      return clr_pv2
    when "M431101029AJ2"
      return clr_pv3
    when "M461101120AJF"
      return clr_pv4
    when "M461101053AJ8"
      return clr_pv5
    when "M461101194AJ0"
      return clr_pv6
    end

  end

  def label_by_module(m)

    # Module numbers
    label_pv1 = ' (PV1)'
    label_pv2 = ' (PV2)'
    label_pv3 = ' (PV3)'
    label_pv4 = ' (PV4)'
    label_pv5 = ' (PV5)'
    label_pv6 = ' (PV6)'

    case m
    when "M421101006AJB"
      return label_pv1
    when "M431101063AJA"
      return label_pv2
    when "M431101029AJ2"
      return label_pv3
    when "M461101120AJF"
      return label_pv4
    when "M461101053AJ8"
      return label_pv5
    when "M461101194AJ0"
      return label_pv6
    end

  end

end
