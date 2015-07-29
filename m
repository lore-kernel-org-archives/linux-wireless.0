Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34203 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbG2It7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 04:49:59 -0400
Received: by lbbst4 with SMTP id st4so2051387lbb.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2015 01:49:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmonVPdm-Nng2XXUQb8KimRu2tHdoboBe0frKhcb0fENQjA@mail.gmail.com>
References: <1437554563-11712-1-git-send-email-martin.blumenstingl@googlemail.com>
 <CAJ-Vmom5v_Jb6f1ARoa3t99Ruht4zJMYiuS85ydHxCYoKV2n5g@mail.gmail.com>
 <CAFBinCA_zNHgx+a+dikA46GN-xPtPMrtmnXeOHwMjr4FsNF=Cg@mail.gmail.com>
 <CAJ-VmokJwqEvkUMf4BNkW9h-6BPdANjTrjgu0YJMD0RAYfQF2A@mail.gmail.com>
 <CAFBinCCzTTdkENDZ5BVPnSqXV7uFUtBabAYFuT4-sd2M=KVxLg@mail.gmail.com>
 <CAJ-Vmo=pmv6tMs1_AY=x-MS=Q1VAXy0Xrp2ac==Nsm0=njoE8g@mail.gmail.com>
 <CAFBinCDwLBUZcwEh1QBofDg5urwviO9gWKAeiuVXHCyw+OdFfA@mail.gmail.com>
 <CAJ-Vmokfovc806T+Ja6nQhbGUDM=uU7MmKwad6Uc2hNYV+DDtA@mail.gmail.com>
 <CAFBinCDqn5HCb3APpqfFULwrmqPGpuj2upFOC=5qZUZzHWBnVg@mail.gmail.com>
 <CAJ-VmonRw=htFB+xNrxa=bgAsERUu+zhXrwvpoj9kONsEfooLw@mail.gmail.com>
 <CAFBinCB43LEj3KJVX7qqY40aKYCq68MYi2AD_5MKk43tj7HeXg@mail.gmail.com>
 <CAJ-Vmom3+aaPjPGAusFbP68-Z3BcY4n=nbyetJDiWdRo4L3fHA@mail.gmail.com>
 <CAFBinCCPouYbKNoyB=z7v0EQKWMhrVJogKvJK=DhqLtwef=zvw@mail.gmail.com> <CAJ-VmonVPdm-Nng2XXUQb8KimRu2tHdoboBe0frKhcb0fENQjA@mail.gmail.com>
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date: Wed, 29 Jul 2015 10:49:38 +0200
Message-ID: <CAFBinCB2bFcvOj=jig4auzopEGkCsS7Vc6J+UhLz7EW2h=pkdQ@mail.gmail.com> (sfid-20150729_105011_492722_E185D8D8)
Subject: Re: [PATCH RESEND] ath9k: Fix NF CCA limits for AR9287 and AR9227
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2015 at 9:49 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> ok, can you re-run this again before the NF patch, so I can compare?
Sure, here they are: [0]

And here are the NF values reported by ath9k right before that:
# cat /sys/kernel/debug/ieee80211/phy1/ath9k/dump_nfcal
Channel Noise Floor : -91
Chain | privNF | # Readings | NF Readings
0       -110    2               -110 -110
1       -110    2               -110 -110


Regards,
Martin

[0] https://dl.dropboxusercontent.com/u/26940713/tmp/spectral_out_nopatch
