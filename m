Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47407 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab0A1QMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2010 11:12:50 -0500
Received: by ewy19 with SMTP id 19so914345ewy.21
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2010 08:12:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <774870.89795.qm@web51401.mail.re2.yahoo.com>
References: <774870.89795.qm@web51401.mail.re2.yahoo.com>
From: rootkit85@yahoo.it
Date: Thu, 28 Jan 2010 17:12:28 +0100
Message-ID: <40101cc31001280812v19e78ad7m3cf04a7ff1851ce0@mail.gmail.com>
Subject: Re: [ath9k-devel] Significiant performance differences between ath5k
	and ath9k in 802.11a
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 28, 2010 at 4:13 PM, Joerg Pommnitz <pommnitz@yahoo.com> wrote:
> Hello all,
> I have a strange performance problem with ath9k. I have two otherwise identical systems with an ath5k-supported card in system ATH5K and an ath9k supported card in system ATH9K.
> Doing an UDP iperf run were ATH5K is the client/sender and ATH9K is the server/receiver I easily get data rates of 31MBit/s (tx data rate on the sender is manually set to 54 MBit/s).
> Running the same test with ATH9K as client/sender and ATH5K as server/receiver gives maximum data rates of about 22MBit/s, about 30% less.
>
> Doing the test against another ath9k system (e.g. ATH9K ==> ATH9K2) gives
> the same max data rate of only 22 MBit/s, so the problem seems to be the
> ath9k driver or the hardware. Can anybody confirm these problems? Is this
> a known limitation? Any buttons to push to get things going faster?
>
> Details:
> the ath5k card is a AR2413 based design (Compex WLM54AG), the ath9k card
> is a AR9220 (Compex WLM200NX 6A). The systems are connected in IBSS mode
> on channel 40 (5200MHz).
> The kernel version is wireless-testing as of January, 26. The kernel is
> slightly patched to enable IBSS in 802.11a (we are allowed to do this).
>
> Can anybody shed some light on this strange issue? Luis?
>
> --
> Regards
>       Joerg
>
> __________________________________________________
> Do You Yahoo!?
> Sie sind Spam leid? Yahoo! Mail verfügt über einen herausragenden Schutz gegen Massenmails.
> http://mail.yahoo.com
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>

Can you try in AP-client mode? I think you'll get more throughput so.
