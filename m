Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35105 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbG1Xhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2015 19:37:34 -0400
Received: by igr7 with SMTP id 7so135874556igr.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2015 16:37:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFBinCB43LEj3KJVX7qqY40aKYCq68MYi2AD_5MKk43tj7HeXg@mail.gmail.com>
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
Date: Tue, 28 Jul 2015 16:37:33 -0700
Message-ID: <CAJ-Vmom3+aaPjPGAusFbP68-Z3BcY4n=nbyetJDiWdRo4L3fHA@mail.gmail.com> (sfid-20150729_013753_618229_F92AA0FB)
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

On 28 July 2015 at 15:33, Martin Blumenstingl
<martin.blumenstingl@googlemail.com> wrote:
> On Wed, Jul 29, 2015 at 12:22 AM, Adrian Chadd <adrian@freebsd.org> wrote:
>> Hm, doesn't someone have a graphical frontend for this on linux?
> Yep, I just found FFT_eval (screenshot: [0] and ath_spectral
> (screenshot [1]) in the ath9k spectral scan wiki page.
>
>
> [0] http://abload.de/img/athscanfjsvv.png
> [1] http://abload.de/img/fft-evaldqsbq.png

Cool! Does it let you capture lots of samples over time and plot them?
Or is the second one that as well?

Is this before or after the NF patches?


-adrian
