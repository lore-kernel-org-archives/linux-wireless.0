Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:45675 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391AbYD1LE6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2008 07:04:58 -0400
Received: by py-out-1112.google.com with SMTP id u52so7687950pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2008 04:04:57 -0700 (PDT)
Message-ID: <ac542ca00804280404h20db4b1cn56a2c5fefc119760@mail.gmail.com> (sfid-20080428_130505_792009_248F6EF8)
Date: Mon, 28 Apr 2008 13:04:57 +0200
From: "Francis Galiegue" <fgaliegue@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: BCM4308 rev 3 owner, willing to help (want to make an access point)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello everyone,

I have a BCM4308 rev 3 based PCI wireless card and eventually want to
make it an access point.

Right now, I use a stock 2.6.25 kernel, with the stock b43 driver and
appropriate firmware. I use an up to date Gentoo, x86-32 (even though
my CPU could do 64).

I've started reading documentation on wireless.kernel.org, and don't
understand much of it (nl80211, mac80211, cfg80211... Many things to
learn about).

Right now I'm stuck at the "setting the card to master mode": iwconfig
wlan0 mode master returns "Invalid argument". The card works fine with
other modes though.

I'm a rookie. However, I'm willing to answer questions/read further
documentation/downloading, compiling kernel, modules, user utilities,
and testing the lot. So, feel free to mail me!

Have fun,
--=20
=46rancis Galiegue, fgaliegue@gmail.com
"It seems obvious [...] that at least some 'business intelligence'
tools invest so much intelligence on the business side that they have
nothing left for generating SQL queries" (St=E9phane Faroult, in "The
Art of SQL", ISBN 0-596-00894-5)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
