Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm4-vm0.bullet.mail.ird.yahoo.com ([77.238.189.211]:32870 "HELO
	nm4-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751793Ab2G3SG3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 14:06:29 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com> <501280BF.4070409@lwfinger.net> <1343394581.87030.YahooMailNeo@web28902.mail.ir2.yahoo.com> <1343398356.19742.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343403507.54955.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343404770.91235.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343407089.96532.YahooMailNeo@web28901.mail.ir2.yahoo.com> <50140463.3080209@lwfinger.net> <1343591834.22699.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5015A2DB.50106@lwfinger.net>
Message-ID: <1343671587.79175.YahooMailNeo@web28901.mail.ir2.yahoo.com> (sfid-20120730_200633_402011_924CEF71)
Date: Mon, 30 Jul 2012 19:06:27 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <5015A2DB.50106@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A part of "modinfo rtl8192ce" says
>parm:  ips:Set to 0 to not use link power save (default 1) (bool)
>
>Load the modules with "sudo modprobe rtl8192ce ips=0" or create the appropriate rtl8192ce.conf file, and power saving is disables.
>
>The RTL8187L, the chip in the AWUS036H will never work in AP mode. It has only one hardware queue, and getting the timing right for beacons is extremely difficult, and not worth the effort.
>
>> Have you had to add parameters in your rtl8192ce.conf file in modprobe?
>Except for testing, I use no module parameters. If any were always necessary, I 
>would change the default.
>
>Larry

Good to know so I will not waste my time with this AWUS036H device.

FYI a good blog on the sharing a wireline and wireless network, setthing up the AP with dhcp, proxy ARP etc...
http://savvyadmin.com/virtualbox-wireless-bridging-with-dhcp/ 


AS you suggested, I only kept ips=0 for my rtl8192ce
/etc/modprobe.d/rtl8192ce.conf 
options rtl8192ce ips=0

# ips:Set to 0 to not use link power save (default 1)
# swlps:Set to 1 to use SW control power save (default 0)
# fwlps:Set to 1 to use FW control power save (default 1)
# debug:Set debug level (0-5) (default 0) (int)

(any cheap, good and working USB wifi device which has more power than an embedded chip as the rtl8188 ? it's a shame that we can't add just an antenna vs another wifi hw)
