Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n28.bullet.mail.mud.yahoo.com ([68.142.206.223]:36417 "HELO
	n28.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751785AbYFRJqU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 05:46:20 -0400
Message-ID: <4858D7CB.1080603@yahoo.it> (sfid-20080618_114624_047350_0DC7F652)
Date: Wed, 18 Jun 2008 11:39:23 +0200
From: Filippo Zangheri <filippo.zangheri@yahoo.it>
MIME-Version: 1.0
To: Michael Leun <linux-wireless@newton.leun.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: compat wireless, i3945, tcpdump: Machine freezes
References: <20080618094213.5abd2fbd@localhost>
In-Reply-To: <20080618094213.5abd2fbd@localhost>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Michael Leun ha scritto:
> Hello,
> 
> I downloaded compat-wireless-2008-06-18, built it, loaded cfg80211.ko,
> mac80211.ko, iwl3945.ko, associated to an ap, started "tcpdump -i wlan0
> -n" and the machine mostly freezed.
> 
> Mostly means keyboard does not work, no disk-access, no network but
> mouse still works.
> 
> This is reproducable, freeze happens instantly after starting tcpdump
> (if a ping runs while I start tcpdump I see one Packet in the output of
> tcpdump, then machine is frozen).
> 
> I've had that with some older versions of compat-wireless also.

Same behaviour here.

I add that the freezes happen when the card is associated to the AP.
They happen with tcpdump and with wireshark, both selecting wmaster0
and wlan0 interfaces; but don't happen with kismet.

Furthermore, I have a PPPoE Internet connection and the computer
freezes even when I try to monitor ppp0 interface (when the PPPoE
connection uses the radio link).

Thanks.

- --
Filippo Zangheri

GPG key ID: 0x6C1F2F2F
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIWNfLjzxMG2wfLy8RAl1IAJ0cOPq2dYMrSkbI4FYeIUGj1RMrLQCeOxaV
CHibU4ueXOnQpOv737f12oI=
=mk9X
-----END PGP SIGNATURE-----

