Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:20454 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbXJUP0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 11:26:53 -0400
Received: by ug-out-1314.google.com with SMTP id z38so802447ugc
        for <linux-wireless@vger.kernel.org>; Sun, 21 Oct 2007 08:26:51 -0700 (PDT)
To: bruno.vetel@wanadoo.fr
Subject: Re: [Fwd: Problem with a Driver rt73 in ad-hoc mode between a arm and a pc]
Date: Sun, 21 Oct 2007 17:45:17 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <1192979624.9056.23.camel@rigel.esas.fr>
In-Reply-To: <1192979624.9056.23.camel@rigel.esas.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710211745.18430.IvDoorn@gmail.com> (sfid-20071021_162657_476286_30AC4597)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I sent also this mail to the linux-kernel because I didn't know this list.

I have added rt2400-devel to the CC-list as well.
Although the name suggests otherwise, that is the mailinglist of the rt2x00 project. ;)

> My board is based on a at91rm9200. I try to connect a dongle wifi
> DWL-G122 (rt73usb) driver in Ad-Hoc mode with a PC ( dongle linksys
> rt73usb but the ubuntu version). I trie also this version on my board
> and the cvs versions with the same problem
> 
> My kernel is a 2.6.23.1 with little modifications to support my board
> which is very closed to the at91rm9200-EK.
> 
> In Managed mode, the dongle works perfectly and I ping a router without
> any problem

Good to hear at least that is working. :)

> In Ad-hoc mode, on the at91 board the cell is detected but I don't see
> any transfer. In debug mode, it seems that beacon and cell are detected
> but only after the driver triggers a new scan.

Could you try using wireshark or a similar tool to see if beacons
are correctly send out?
There are similar reports regarding rt73 which suggests that in adhoc mode
the beacons are never being send out correctly.

Ivo
