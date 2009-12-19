Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46166 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZLSKTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2009 05:19:30 -0500
Received: by bwz27 with SMTP id 27so2632032bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 19 Dec 2009 02:19:29 -0800 (PST)
MIME-Version: 1.0
Reply-To: andreamrl@tiscali.it
In-Reply-To: <20091219003746.GF2512@florz.florz.dyndns.org>
References: <20091218180205.GD2512@florz.florz.dyndns.org>
	<4B2BC7E3.2050907@lwfinger.net> <20091218185916.GE2512@florz.florz.dyndns.org>
	<4B2C100A.9000507@lwfinger.net> <20091219003746.GF2512@florz.florz.dyndns.org>
From: Andrea Merello <andreamrl@tiscali.it>
Date: Sat, 19 Dec 2009 11:19:09 +0100
Message-ID: <c68f135e0912190219y70371149s605ed4756e02c9d2@mail.gmail.com>
Subject: Re: Power consumption of RTL8187 (driver)/recommendations for
	low-power USB 802.11 adapter?
To: Florian Zumbiehl <florz@florz.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, herton@mandriva.com.br,
	htl10@users.sourceforge.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yeah - plus, the chip, according to realtek's website, wants 3.3 and
> 1.something V. If they are using a linear regulator for that - there must
> be a reason for that low price, after all ... ;-)

Hmm they are using at least one switching DC/DC..

On my rtl8187L there is a relatively big inductor and a big, probably
schottky, diode on the PCB near to two little ICs (well one is
certainly an IC, the other could be even a couple of transistors in a
single package.. I don't know).

On one of two coil pin the 3.3V is present. So it should be the
switching DC/DC for the 3.3.

On one of the two ICS (the little one, that i'm not sure what is it
really) there is present both 3.3V and 1.8V so it could be the
regulator for 1.8V

There are a couple of little inductors or ferrite bead in apparently
0803 or similar package but they looks like they are used as filters
and I can't see any other diode, so the little ic _might_ be a linear
used for 1.8V.

Unfortunately I couldn't find the marking code on the net about it..
it is a sot23-5 marked ajp22

Oh And there is another of those ajp22 on another PCB place...I did
some measurement on it, but I didn't find anything that convinced me
about what is it..

Andrea
