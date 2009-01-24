Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41998 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762AbZAXF66 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 00:58:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Automatically probe for opensource firmware
Date: Sat, 24 Jan 2009 06:58:35 +0100
Cc: linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
References: <200901232121.52012.mb@bu3sch.de> <497AA16F.30409@lwfinger.net>
In-Reply-To: <497AA16F.30409@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901240658.35490.mb@bu3sch.de> (sfid-20090124_065905_201700_CCDDD7FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 24 January 2009 06:04:47 Larry Finger wrote:
> Michael Buesch wrote:
> > First probe for proprietary firmware and then probe for opensource firmware.
> > This way around it's a win-win situation.
> > 1) If proprietary fw is available, it will work.
> > 2) If opensource firmware is available, but no proprietary (Distros can only ship open fw)
> >    it might work.
> > 3) If both open and proprietary are available, it will work, because it selects
> >    the proprietary. We currently don't prefer the open fw in this case, because it doesn't
> >    work on all devices. It would introduce a regression otherwise.
> > 
> > The remaining FIXMEs in this patch are harmless, because they only matter on multiband
> > devices, which are not implemented yet anyway.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > ---
> > 
> > John, please queue for the next feature round.
> 
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> I made one temporary change to search for open-source firmware before
> the proprietary version because I boot kernels that are not changed to
> handle the o-s version, but still want to test when I can.
> 
> I understand and approve of your logic - it just doesn't fit my
> current agenda.

You can still use the fwpostfix module parameter, of course.

-- 
Greetings, Michael.
