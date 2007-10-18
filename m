Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2683 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759663AbXJRViw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 17:38:52 -0400
Date: Thu, 18 Oct 2007 17:07:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/4] ath5k: Misc cleanups
Message-ID: <20071018210748.GE8510@tuxdriver.com> (sfid-20071018_223858_534977_2DF55053)
References: <40f31dec0710161418m72e991b2x36428e39f0766e1c@mail.gmail.com> <4af2d03a0710161507h7fac4117k168c592dd31c7dff@mail.gmail.com> <40f31dec0710161512q78c21fbv9426817972db2d1d@mail.gmail.com> <43e72e890710161517k6f53661arba82c83f304c139a@mail.gmail.com> <40f31dec0710171434p7a9ed6f3y66bf862b17633559@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0710171434p7a9ed6f3y66bf862b17633559@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 18, 2007 at 12:34:14AM +0300, Nick Kossifidis wrote:
> 2007/10/17, Luis R. Rodriguez <mcgrof@gmail.com>:
> > On 10/16/07, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > > 2007/10/17, Jiri Slaby <jirislaby@gmail.com>:
> > > > On 10/16/07, Nick Kossifidis <mickflemm@gmail.com> wrote:
> > > > > Some cleanups i did today, just to get used to git etc, hope i'm doing
> > > > > this right ;-)
> > > >
> > > > Patches seems to be fine, thanks for them, but your e-mailer seems to
> > > > wrap lines and change tabs to 8 spaces in your patches, which makes it
> > > > unmergeable...
> > > >
> > >
> > > Ouch ! Sorry for that, it seems gmail did it again. Can i send them as
> > > attachments ???
> >
> > Here's a guide to use gmail with mutt, then you can send as inline attachments.
> >
> > http://people.aapt.net.au/~adjlstrong/mutt.html
> >
> > Worked for me.
> >
> >   Luis
> >
> 
> Just tried to commit from another acount (mick@ics.forth.gr) with
> squirellmail and last one with horde, let's see how it will arive. If
> it doesn't work i'll try with mutt and gmail...

There was still some line-wrapping.  I fixed 1-3 by hand, but 4
("ath5k: Maintain naming scheme") just had too many instances for me to
fix-up.  Please do try to use mutt or another "sane" MUA in the future.

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
