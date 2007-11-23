Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:3519 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXKWKya (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 05:54:30 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: AR5006X on Fijitsu-Siemens Lifebook E8410 - not work
Date: Fri, 23 Nov 2007 11:54:56 +0100
Cc: "Michael Renzmann" <mrenzmann@madwifi.org>,
	"Nick Kossifidis" <mickflemm@gmail.com>, "Majo" <virec@inmail.sk>
References: <200711222310.01165.virec@inmail.sk> <40f31dec0711221538i503119b7hdeffbbde50629a6c@mail.gmail.com> <58948.84.58.144.191.1195794193.squirrel@webmail.madwifi.org>
In-Reply-To: <58948.84.58.144.191.1195794193.squirrel@webmail.madwifi.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711231154.56712.hs4233@mail.mn-solutions.de> (sfid-20071123_105432_685652_7354DE98)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Don't be fooled by the PCI ID - we already know that these are
> not reliable to identify the chipset used on a Atheros-based
> card. See also http://madwifi.org/ticket/1192.

While I was working with Windows XP Embedded (after a long 
absence from Windows), I noticed that they don't just work with 
PCI IDs, but also with PCI-Subsystem IDs.

$ lspci -vn
03:00.0 0200: 168c:0013 (rev 01)
        Subsystem: 1186:3a12
        ...

If vendors would make the subsystem ID wrong, then even Windows 
XP wouldn't be able to detect the card correctly. That's quite a 
big incentive to get that number right :-)
