Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm3-vm0.bullet.mail.ird.yahoo.com ([77.238.189.213]:24468 "HELO
	nm3-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751484Ab2A1HBS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 02:01:18 -0500
Message-ID: <1327733677.67732.YahooMailClassic@web29505.mail.ird.yahoo.com> (sfid-20120128_080141_995325_3923C4B1)
Date: Sat, 28 Jan 2012 06:54:37 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: Fwd: Question regarding Linux RTL driver
To: Nikola Gacic <empnik@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(added CC'ed to the correct mailing list).

No, what you did was wrong - unless you are recruiting for private consultants and want to pay for one-to-one consultation, the appropriate way of contacting is via/Cc'ing one of the mailing lists. (and go by the usual rules, like no html-styled e-mail, etc, which you also broke).

That said - you have not mentioned any debugging information or any method you tried; nor code snipplets of your work. There is nothing to work on, other than "read my mind". So until you can do that, there is nothing to say.

--- On Thu, 26/1/12, Nikola Gacic <empnik@gmail.com> wrote:

From: Nikola Gacic <empnik@gmail.com>
Subject: Fwd: Question regarding Linux RTL driver
To: htl10@users.sourceforge.net
Date: Thursday, 26 January, 2012, 17:36

Hello Mr. Leung,

    I don't know if this is the right way for contacting you but I couldn't find the other way.
    Firstly, I want to say that I am student at School of electrical Engineering in Belgrade and I am working on some embedded project where I tried to use you RTL8187 Linux driver to communicate with PIC32 microcontroller over USB.




    I would appreciate any help with my problem. If you could spare some time to read this it would be great. I have several questions. Initialization worked fine I think (I get ACK packets), but when I try to finally send IN packet to endpoint 0x81 I get NAK packets all the time!




    I checked code in microcontroller several times and, of course, maybe error could be somewhere in initialization, but would that block my IN packets to device? I know that PIC32 cannot work in high-speed mode, only  in full-speed, but in the datasheet for this dongle it says it can work in full-speed. So I want to know does USB card set its speed to full-speed automatically?




    I think my understanding of driver code is good so you can give me some general guidelines regarding initialization if you don't want to go to details.Thank you in advance.

Kind regards,
Nikola Gacić










