Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44034 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751994AbYFEVN3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 17:13:29 -0400
Message-ID: <4848577F.50802@gmx.de> (sfid-20080605_231335_947294_2F09F2B9)
Date: Thu, 05 Jun 2008 23:15:43 +0200
From: Joe <wirelesss@gmx.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Glossary for all words
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey guys,

first of all I want to tell you all my commendation for your fine work.=
=20
Right now I'm reading your source code to understand your code. In the=20
future I'm interested in extending (may be I would have to hack somehow=
)=20
your code. Currently I'm most familiar with upper level usage of WLAN -=
=20
especially Ad Hoc mode. Now I got a possibility to dig into the linux=20
kernel and into the maclayer of WLAN for the next years / month during=20
my phd thesis. During reading I got some problems understanding some of=
=20
the abbreviations in your code.
Thereby I was thinking a glossary for your framework could be helpful=20
for future newbies.

Would you like to help me withit?

Abbrev: English / German
If: Interface / Schnittstelle
Tx: Transmitter / Sender
Rx: Receiver / Empf=E4nger
STA: State / Status
skb: ?
wiphy: Wireless physical
ops:
vif: ? virtual interface
hw: Hardware?
rtnl:
pid: Process id


When I will have understood the code, I'm interested in sending Beacon=20
frames 'manually' and during this step reconfigure the Beacon data=20
regularly...

=46or now all the Best
Sebastian


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
