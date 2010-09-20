Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:50714 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab0ITUE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 16:04:58 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Sep 2010 13:04:52 -0700
Date: Mon, 20 Sep 2010 13:04:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH 2/2 v2] compat-wireless: "backport" pcmcia api changes.
Message-ID: <20100920200456.GA1967@tux>
References: <1284918553-32365-1-git-send-email-hauke@hauke-m.de>
 <1284918969-19315-1-git-send-email-hauke@hauke-m.de>
 <AANLkTikAszZ3tLf90d0AnBe-42c87GFpRfbh2EbMZhTT@mail.gmail.com>
 <4C97B5E6.20505@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C97B5E6.20505@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 20, 2010 at 12:28:38PM -0700, Hauke Mehrtens wrote:
> On 20.09.2010 17:26, Luis R. Rodriguez wrote:
> > On Sun, Sep 19, 2010 at 10:56 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> >> The PCMCIA API changed again.
> >> This patch was only compile tested, beacuse I do not have devices to
> >> test this.
> >>
> >> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> > 
> > mcgrof@tux ~/devel/compat-wireless-2.6 (git::master)$ patch -p1 <
> > /home/mcgrof/patches/2010/09/20/02-cw.patch
> > patching file patches/24-pcmcia.patch
> > Hunk #1 succeeded at 1 with fuzz 1.
> > Hunk #2 FAILED at 13.
> .....
> > 49 out of 50 hunks FAILED -- saving rejects to file patches/24-pcmcia.patch.rej
> > 
> > We should just remove PCMCIA, at the summit no Linux distribution
> > present indicated their desire to keep it alive and maintained within
> > compat-wireless. This should save us some work.
> > 
> >   Luis
> Hi Luis
> 
> That is strange. Something must have went wrong when applying this
> patch. I just checked out a fresh compat-wireless tree and tried to
> apply the mail with git am ... and it worked with some warnings.
> 
> When the next big API change in the pcmcia subsystem arrives we should
> really drop it, but for now it should at least compile and probably
> work. I will resend the a patch rebased on todays compat-wireless.

Applied and pushed thanks.

  Luis
