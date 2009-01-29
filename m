Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:42823 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758273AbZA2NoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 08:44:10 -0500
Received: from localhost ([127.0.0.1] helo=www.phantomjinx.co.uk)
	by vilya.visn.co.uk with esmtpa (Exim 4.69)
	(envelope-from <p.g.richardson@phantomjinx.co.uk>)
	id 1LSWHp-0003jn-32
	for linux-wireless@vger.kernel.org; Thu, 29 Jan 2009 12:46:25 +0000
Message-ID: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk> (sfid-20090129_144420_763073_F9195D72)
Date: Thu, 29 Jan 2009 12:46:25 -0000 (UTC)
Subject: rtl8187 wireless issues
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I recently bought a new laptop from Novatech.co.uk
(http://www.novatech.co.uk/novatech/range.html?t=3Dnb&c=3Dall&r=3DX60).

I have installed Mandriva 2009 (2.6.27-7) on the laptop and despite bes=
t
efforts cannot make the internal wifi card connect to my router. The ca=
rd
is reported by lsusb as

id: 0x8189 chipset: rtl8187b

I use WPA2 with a pre-shared key on my router. Would you mind giving me
guidance as to whether this is relibaly working with the rtl8187 driver=
?

Basically, I am unable to associate with the router. Looking at
wpa_supplicant debug output, it indicates the card simply times out whe=
n
trying to associate. However, on one brief occasion a couple of days ag=
o,
I was able to associate according to iwconfig, yet despite best efforts=
 I
was unable to ping anything.

It seems as well that when the driver is installed (currently blacklist=
ed
in modprobe.conf), it stops other network interfaces operating correctl=
y.
=46or example, I am unable to ping from a wired ethernet and unable to
associate with the AP with an externel wireless USB dongle.

I have since tried the 2.6.29 kernel from its git repository but that
version of the rtl8187 driver did not associate either.

At this point I am constrained by lack of debugging knowledge. The only
tools I know of is iwconfig and friends, wpa_supplicant -ddd and ifconf=
ig.
If someone wouldnt mind giving me an idea of how to approach debugging
this problem then I could try and understand what is going on myself.

Any help very much appreciated.

Thanks

P. G. Richardson
(a.k.a phantomjinx)

--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
