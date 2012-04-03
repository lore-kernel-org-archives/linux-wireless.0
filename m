Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49667 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753684Ab2DCWsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 18:48:54 -0400
Message-ID: <4F7B75DF.2040008@iki.fi> (sfid-20120404_004857_506388_E7C2C051)
Date: Wed, 04 Apr 2012 01:12:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
CC: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: GSoC: open firmware for ath9k_htc
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!
I am information engineering student of University of Oulu, Department 
of Computer Science and Engineering, from Finland EU.

I have applied GSoC project called open firmware for ath9k_htc. It was 
the really only somehow interesting topic as I would like to do 
something Kernel related.
http://wireless.kernel.org/en/developers/GSoC/2012/ath9k_htc_open_firmware

I am active developer of the Linux-Media subsystem. My main 
contributions are big amount of digital television chip and device 
drivers. More about that can be found from my personal project page.
http://palosaari.fi/linux/

As I see that GSoC project needs some embedded skills and many are 
surely interested to known if I have enough experience. Unfortunately I 
don't have embedded experience as much as Kernel driver development 
experience, but I think I still have rather good understanding which 
should be enough for success project. Also I think it is worth to 
mention I have rather much protocol reverse-engineering expertise, 
especially USB and I2C, coming from the Linux DVB hacking.


Here is a list of embedded projects I quickly remember, not all, but 
likely the biggest ones still.


Embedded thermometer. School project. Own made PCB, Philips 89C52 MCU 
(Intel 8052 clone), two I2C controllable temperature sensors, two relays 
and LCD display. Programming language C.


Learning remote controller. School project. Own made PCB, Atmel ATmega32 
MCU, LCD display, JTAG, IR receiver, IR sender, few buttons. Programming 
language C.
http://palosaari.fi/img_1305.jpg


SIP phone. School project. Hardware was Atmel ATmega128 MCU based board 
called Ethernut2.1. Only some very limited SIP stack and ethernet 
networking was implemented. RTP, meaning voice codecs, was not done. 
Programming language C.
http://www.ethernut.de/en/hardware.html


"Egg-timer". School project. Atmel ATmega128 MCU based development board 
called Olimex AVR-MT-128. LCD display, buzzer, relay, few buttons. I 
coded running Pacman for the LCD screen top of all required 
functionality :) Programming language C.
http://www.olimex.com/dev/avr-mt128.html


Test firmware for one Cypress EZ-USB FX2LP based DVB USB device. Cypress 
FX2 is general and very common USB -interface chip. Firmware I did was 
based of open Termini design. Due to that relative small amount changes 
was needed.
http://www.cypress.com/?id=193
http://linuxtv.org/cgi-bin/viewvc.cgi/dvb-hw/dvbusb-fx2/


Electric meter. School project. FPGA. Hardware was Altera DE2 
development board, featuring an Altera Cyclone II 2C35 FPGA. [6]
http://www.altera.com/education/univ/materials/boards/de2/unv-de2-board.html


After all I haven't got too many answers about that project. It sounds 
like something overkill to make WLAN firmware from the scratch, but in 
my understanding here is somehow working skeleton that can be use as a 
example which reduces of course workload.

regards
Antti
-- 
http://palosaari.fi/
