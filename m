Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33719 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbbG2HtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 03:49:04 -0400
Received: by igbpg9 with SMTP id pg9so161651404igb.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2015 00:49:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFBinCCPouYbKNoyB=z7v0EQKWMhrVJogKvJK=DhqLtwef=zvw@mail.gmail.com>
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
	<CAFBinCCPouYbKNoyB=z7v0EQKWMhrVJogKvJK=DhqLtwef=zvw@mail.gmail.com>
Date: Wed, 29 Jul 2015 00:49:02 -0700
Message-ID: <CAJ-VmonVPdm-Nng2XXUQb8KimRu2tHdoboBe0frKhcb0fENQjA@mail.gmail.com> (sfid-20150729_094908_775985_89A6388F)
Subject: Re: [PATCH RESEND] ath9k: Fix NF CCA limits for AR9287 and AR9227
From: Adrian Chadd <adrian@freebsd.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ok, can you re-run this again before the NF patch, so I can compare?

And yeah, I can compile up fft_eval for freebsd. I think I've done it
once or twice before..


-a


On 28 July 2015 at 16:43, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> On Wed, Jul 29, 2015 at 1:37 AM, Adrian Chadd <adrian@freebsd.org> wrote:
>> Cool! Does it let you capture lots of samples over time and plot them?
> At least FFT_eval would allow capturing samples, but the device with
> the AR9227 is a small router -> no screen there, so I have to dump it
> on that device, copy it to my PC and look at the samples there.
> I have also just seen that in FFT_eval one can "Navigate through the
> currently selected datasets using the arrow keys (left and right)."
> This would require me to make many screenshots. Is there a chance you
> can compile FFT_eval on FreeBSD (it "only" seems to require SDL and
> SDL_ttf) and run it yourself?
>
>> Or is the second one that as well?
> What do you mean exactly?
>
>> Is this before or after the NF patches?
> This is after my NF patch.
>
>
> Regards,
> Martin
