Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:33949 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZA3IRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 03:17:53 -0500
Received: by rn-out-0910.google.com with SMTP id k40so252556rnd.17
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 00:17:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <498269D5.7080204@openwrt.org>
References: <498269D5.7080204@openwrt.org>
Date: Fri, 30 Jan 2009 10:17:51 +0200
Message-ID: <40f31dec0901300017g2504e494mc75db9d9a0ffca7@mail.gmail.com> (sfid-20090130_091758_355179_EF0D9174)
Subject: Re: [PATCH,RFC 0/2] ath5k: implement tx power calibration on
	ar2413/5413
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/30 Felix Fietkau <nbd@openwrt.org>:
> Hi,
>
> I got my AR2413 patches to the point where ath5k properly
> initializes the PDGAIN curves (register dumps verified against
> what the madwifi HAL does), and it does Tx at much better
> power level and with 54 Mbit (tested on an AR5413 card).
> Power still isn't as good as on madwifi yet, but much closer
> than before, and I actually get >20Mbit/s throughput now.
>
> Enjoy!
>
> - Felix
>

You are the man !

I'm sending some patches that update phy.c, initvals.c and reset.c etc
today and i'll merge this one with RF5111/RF5112 pcdac stuff and tpc
support asap to have power table support for all chips. We also need
to work out regulatory stuff before we fully enable tx power support
so i have to test this on a spectrum analyzer.

Just give me some time and i'll come back with code ;-)

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
