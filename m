Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:46590 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaJMMH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 08:07:57 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: <ath10k@lists.infradead.org>,
	"'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A319018C2750@sbs2003.acksys.local>	<CA+BoTQ=a8kY0CGGKHwRhk4cg=V0oimipuht6Pkc0K0x4WMMn-A@mail.gmail.com>	<024a01cfe6c7$5e427dd0$1ac77970$@acksys.fr> <CA+BoTQkaKXNfprRwGrQq6rKOZWvANNRrcmgU-iVdw1bONTA--w@mail.gmail.com>
In-Reply-To: <CA+BoTQkaKXNfprRwGrQq6rKOZWvANNRrcmgU-iVdw1bONTA--w@mail.gmail.com>
Subject: RE: ath10k firmware crash
Date: Mon, 13 Oct 2014 14:06:51 +0200
Message-ID: <025801cfe6de$2d4c7f70$87e57e50$@acksys.fr> (sfid-20141013_140801_666243_0C2A36E2)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> > Have you a benchmark reference with ATH10K ? at this time we can send
> around 700 Mbit/s, is it the maximum or we can expected better ?
> 
> If this is OTA then this is pretty good. If this is cabled RF w/ attentuator
> it should be possible to get ~900mbps of UDP traffic with multiple streams on
> iperf. At least that's what I was getting on 10.1 firmware (on both AP and
> STA) last time I checked.
> 
> Getting more than 700mbps OTA requires AP and STA antenna alignment voodoo.
> 
I did some tests with a linksys WRT1900AC and I have ~950 mbps OTA easily.
> 
> Michał
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html

