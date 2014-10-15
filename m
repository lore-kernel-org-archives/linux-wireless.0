Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp28.msg.oleane.net ([62.161.4.28]:36533 "EHLO
	smtp28.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaJONGS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2014 09:06:18 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Bartosz Markowski'" <bartosz.markowski@tieto.com>
Cc: "'Michal Kazior'" <michal.kazior@tieto.com>,
	"'ath10k'" <ath10k@lists.infradead.org>,
	"'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local>	<CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>	<024a01cfe6c7$5e427dd0$1ac77970$@acksys.fr>	<CA+BoTQkaKXNfprRwGrQq6rKOZWvANNRrcmgU-iVdw1bONTA--w@mail.gmail.com>	<025801cfe6de$2d4c7f70$87e57e50$@acksys.fr> <CACKGw+H1QSvAL0Ri3HT6E_rhw=DhzDwj1XEeqwjwFkzJVQpz9Q@mail.gmail.com>
In-Reply-To: <CACKGw+H1QSvAL0Ri3HT6E_rhw=DhzDwj1XEeqwjwFkzJVQpz9Q@mail.gmail.com>
Subject: RE: ath10k firmware crash
Date: Wed, 15 Oct 2014 15:05:09 +0200
Message-ID: <02f001cfe878$a64038e0$f2c0aaa0$@acksys.fr> (sfid-20141015_150621_352029_96638BB5)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I did some tests with a linksys WRT1900AC and I have ~950 mbps OTA easily.
> 
> You mean ath10k (STA) VS WRT1900AC get up ~950mbps?
> If so, could you say what's the HW, FW version you use?
> 
My test platform is one WRT1900AC set in bridge mode with a computer.

If I use the WRT1900AC in AP mode with another computer, I have 950 mbps
If I use the cavium octon III dev plateform + ath10k driver in AP mode, I have around 700 mbps

I'm using the latest compat wireless (2014-09-26) from openwrt.
The wireless card is the WLE900VX from compex or DAXA-O1 from Unex.

The WRT1900AC have mimo 4x4 with 3 streams, and my wireless card have mimo 3x3 with 3 streams. Maybe that explains the difference.

Cedric Voncken.
> --
> Bartosz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

