Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47688 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab1JDRts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 13:49:48 -0400
Received: by ywb5 with SMTP id 5so741770ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 10:49:47 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Adrian Chadd <adrian@freebsd.org>
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
Date: Tue, 4 Oct 2011 19:49:35 +0200
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <201110041842.05218.chunkeey@googlemail.com> <CAJ-Vmo=1riCHbC56_UR+EXUrB6T_=_FjTdNKFm6-XuSq2UOTzg@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=1riCHbC56_UR+EXUrB6T_=_FjTdNKFm6-XuSq2UOTzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201110041949.35321.chunkeey@googlemail.com> (sfid-20111004_194951_646509_341A86A7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, October 04, 2011 07:03:10 PM Adrian Chadd wrote:
> Nope, what I'm saying is that someone's likely just copy/paste'd the
> "we support x and y!" from some marketing material and then suggested
> people use linux/openwrt/ath9k without really looking at it.
I'm still curious how they got the Apple access point through the FCC
testing back then. Well, I guess we'll never know for sure.
 
> There were plenty of people advertising the AR9160 as a "3x3 MIMO"
> when it's a 2x2 stream device with 3 antennas. I know this confused me
> when I started tinkering with wifi stuff.
AFAIK the 3x3 really just stands for the amount of tx X rx chains [and
not antennas]. So if the hardware has 3 tx and rx chains it can be sold
as a "3x3" device even if does not support 3 streams.

> Anyway, we're getting off-track here.
we can stop anytime.
