# frozen_string_literal: true

# class for Controller
class Controller
  def all_invoices
    Invoice.join(Car.select(Sequel[:id].as(:car_id), :registration_number), car_id: :car_id).all
  end

  def invoice(invoice_id)
    Invoice.where(id: invoice_id).join(Car.select(Sequel[:id].as(:car_id), :registration_number), car_id: :car_id).first
  end

  def print_invoice(invoice_id)
    invoice = invoice(invoice_id)
    if invoice
      puts "
Invoice Details:
Invoice number: #{invoice[:id]}
Registration Number: #{invoice[:registration_number]}
Entry Time: #{invoice[:entry_time].strftime('%B %d, %Y %T IST')}
Exit Time: #{invoice[:exit_time].strftime('%B %d, %Y %T IST')}
Duration: #{invoice[:duration]} secs
Amount: #{invoice[:invoice_amount]}"
    else
      puts 'No Invoice Found'
    end
  end

  def print_all_invoices
    invoices = all_invoices
    puts "Invoice number\tRegistration Number\tEntry Time\t\t\tExit Time\t\t\tDuration\tAmount"
    invoices.each do |invoice|
      puts "#{invoice[:id]}\t\t#{invoice[:registration_number]}\t\t#{invoice[:entry_time].strftime('%B %d, %Y %T IST')}\t#{invoice[:exit_time].strftime('%B %d, %Y %T IST')}\t#{invoice[:duration]} secs\t\t#{invoice[:invoice_amount]}"
    end
  end
end
