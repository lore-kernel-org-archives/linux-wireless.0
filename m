Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46781 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab2EZMgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 08:36:00 -0400
Message-ID: <4FC0CE2B.9060005@openwrt.org> (sfid-20120526_143606_778233_558C6BA2)
Date: Sat, 26 May 2012 14:35:55 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Josef Semler <josef.semler@gmail.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL> <7759D07D-C2C8-48D8-8F44-687C7E85D188@gmail.com> <20416.35246.76971.129331@gargle.gargle.HOWL> <CAPsaeQPxh0Yd+GT3HbReAAtoPhKF2c3kOzgOPL6xK7NC=8J4qA@mail.gmail.com>
In-Reply-To: <CAPsaeQPxh0Yd+GT3HbReAAtoPhKF2c3kOzgOPL6xK7NC=8J4qA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-05-26 9:55 AM, Josef Semler wrote:
> 
> 
> 2012/5/26 Sujith Manoharan <c_manoha@qca.qualcomm.com
> <mailto:c_manoha@qca.qualcomm.com>>
> 
>     Joe Semler wrote:
>     > > With a XB112 card (3x3) in HT40 mode, 5Ghz, TX throughput (TCP)
>     can reach 290 Mbps.
>     > > Sample iperf run:
>     > >
>     > > [  3] 28.0-29.0 sec  34.1 MBytes   286 Mbits/sec
>     > > [  3] 29.0-30.0 sec  34.6 MBytes   290 Mbits/sec
>     > > [  3] 30.0-31.0 sec  34.8 MBytes   292 Mbits/sec
>     > > [  3] 31.0-32.0 sec  34.8 MBytes   292 Mbits/sec
>     > > [  3] 32.0-33.0 sec  34.9 MBytes   293 Mbits/sec
>     >
>     > Do you use ath9k for that purpouse? I was thinking our driver is
>     not able to operate MIMO.
>     > Some changes that i missed?
> 
>     Yes, those numbers are with ath9k, with latest wireless-testing.
> 
> OK, tnx Sujith, but that brings me to my next question acc. 2x2 or 3x3
> on OpenWRT-based devices like NanoStation M or AirBridge M.
> Up to now only 1x2 or 1x3 was possible on this devices. Do we have
> changings there too?
Why do you think that only 1x2 or 1x3 was possible on these devices? 2x2
and 3x3 has been working just fine for a long time now, and it's enabled
by default where supported by the hardware.

- Felix
