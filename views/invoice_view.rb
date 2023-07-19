# frozen_string_literal: true

# View Class for Invoice
module InvoiceView
  def self.print_invoice(invoice)
    if invoice
      puts "
Invoice Details:\nInvoice number: #{invoice[:id]}\nRegistration Number: #{invoice[:registration_number]}
Entry Time: #{invoice[:entry_time].strftime('%B %d, %Y %T IST')}
Exit Time: #{invoice[:exit_time].strftime('%B %d, %Y %T IST')}
Duration: #{invoice[:duration]} secs\nAmount: #{invoice[:invoice_amount]}"
    else
      puts 'No Invoice Found'
    end
  end

  def self.print_all_invoices(invoices)
    if invoices.empty?
      puts 'No Invoices Found'
    else
      puts "Invoice number\tRegistration Number\tEntry Time\t\t\tExit Time\t\t\tDuration\tAmount"
      invoices.each do |invoice|
        puts "#{invoice[:id]}\t\t#{invoice[:registration_number]}\t\t#{invoice[:entry_time]}\t#{invoice[:exit_time]}\t#{invoice[:duration]}\t\t#{invoice[:invoice_amount]}"
      end
    end
  end
end
