Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:36558 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbJENgr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 09:36:47 -0400
Received: by igcrk20 with SMTP id rk20so60705462igc.1
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2015 06:36:47 -0700 (PDT)
Date: Mon, 5 Oct 2015 08:36:07 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: wireless-regdb <wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/5] wireless-regdb: Update TW and US rules to latest
 regulations
Message-ID: <20151005133607.GA21639@ubuntu-hedt> (sfid-20151005_153650_846556_974DBBC9)
References: <1443682667-29814-1-git-send-email-wens@csie.org>
 <20151001212601.GE101875@ubuntu-hedt>
 <CAGb2v67RBbzo-Q1S4xo63=TFqkLxMtN_FHiSa7Yi=ahKw9xi-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGb2v67RBbzo-Q1S4xo63=TFqkLxMtN_FHiSa7Yi=ahKw9xi-g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2015 at 01:28:22PM +0800, Chen-Yu Tsai wrote:
> On Fri, Oct 2, 2015 at 5:26 AM, Seth Forshee <seth.forshee@canonical.com> wrote:
> > On Thu, Oct 01, 2015 at 02:57:42PM +0800, Chen-Yu Tsai wrote:
> >> Hi Seth,
> >>
> >> This is v3 of my TW/US 5GHz updates series. Sorry for the long delay.
> >>
> >> Changes since v2:
> >>
> >>   - Moved the US U-NII-1 (5150 ~ 5250 MHz) patch in front of the TW patch
> >>
> >>   - Drop U-NII-1 power limit from 24 dBm to 23 dBm, to be on the safe
> >>     side of 250mW
> >>
> >>
> >> Patch 1 updates the 5470 ~ 5725 MHz rules for Taiwan, specifically
> >> the opening up of 5600 ~ 5650 MHz spectrum previously allocated to
> >> weather radars. The transmission power limit is also corrected to
> >> match the regulations.
> >>
> >> Patch 2 changes the boundary frequencies for each rule for Taiwan to
> >> match the frequency allocation table. The "regulation" database shouldn't
> >> care about artificial channel boundaries.
> >>
> >> Patch 3 updates the transmission power limits for 5150 ~ 5250 MHz for
> >> the US.
> >>
> >> Patch 4 adds the previously unusable 5150 ~ 5250 MHz band for Taiwan.
> >>
> >> Patch 5 updates the transmission power limits for Taiwan, per the NCC's
> >> official reply. This patch may be slightly controversial, as there is
> >> no official English document. Either someone will have to independently
> >> verify this, or translate the Chinese document.
> >
> > This description doesn't quite match the patches. Patch 4 both adds the
> > 5150-5250 MHz band and increases the power limits for 5250-5350 MHz,
> > whereas patch 5 changes the DFS master region to DFS-FCC. Previously the
> > increased power limit for 5250-5350 MHz was part of patch 5 - perhaps
> > you accidentally moved that part to patch 4 when you were updating the
> > patches?
> 
> Indeed. I squashed a fixup into the wrong patch, and tried to fix it.
> Obviously that didn't work out so well.
> 
> > So patches 1-3 look fine to me. I suspect you'll want to move the power
> > limit increase from patch 4 to 5. I'm also going to take a look at a
> > machine translation of the Chinese document, and if that looks to be in
> > agreement with your patches then I should be able to apply them next
> > week sometime.
> 
> Do you want me to send a new version now, or wait for you to go through
> the translation first?

I've taken a look at the translation, and as far as I can tell what
you've done looks okay. So go ahead and resend, and as long as no one
else finds a problem I'll apply all 5.

Thanks,
Seth
