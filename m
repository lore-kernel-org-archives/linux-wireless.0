Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:34631 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZBCQle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 11:41:34 -0500
Received: by nf-out-0910.google.com with SMTP id d3so299440nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 08:41:32 -0800 (PST)
Subject: Re: [ath5k-devel] [PATCH 1/5] ath5k: PHY code cleanup
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
In-Reply-To: <40f31dec0902030824s65b90222j13ac9b691593f19f@mail.gmail.com>
References: <20090131022310.GA3342@makis>
	 <1233670130.16539.5.camel@maxim-laptop>
	 <40f31dec0902030817h4afacc52uea4885d835444aac@mail.gmail.com>
	 <40f31dec0902030824s65b90222j13ac9b691593f19f@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 18:41:27 +0200
Message-Id: <1233679287.11183.7.camel@maxim-laptop> (sfid-20090203_174139_535769_1C8A4431)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-02-03 at 18:24 +0200, Nick Kossifidis wrote:
> 2009/2/3 Nick Kossifidis <mickflemm@gmail.com>:
> > 2009/2/3 Maxim Levitsky <maximlevitsky@gmail.com>:
> >> I just tried your 5 patches, as they could fix hangs in the device,
> >> that I experience occasionally, when resuming my aspire one from
> ram.
> >>
> >> I applied the patches, and I got very unstable system, that tended
> to
> >> hang even before X.
> >>
> >> When it didn't hang, I tried suspend to ram cycle, but it hanged
> then.
> >>
> >>
> >> Best regards,
> >>        Maxim Levitsky
> >>
> >>
> >
> > It's related to unhandled BMISS interrupts, Bob is working on it to
> > see what triggers them. A quick solution is to disable them (as we
> > don't handle them anyway) but it would be better to know the
> problem.
> >

Acer aspire one.

-wireless-testing tree + 5 patches
I test without X running, maybe I could spot an oops or so,
currently, system just hangs cold.

Best regards,
	Maxim Levitsky

PS:

Atheros devices consist of MAC and PHY (which sometimes is called radio)

It seems that my device has 2425 MAC, but what radio it has?
It also seems that most of the driver treats it as a AR5112.
I thought before that 5112 was the MAC and 2425 was the radio, but it
doesn't seem to be true, can you explain this?


 

