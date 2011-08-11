Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49804 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1HKQPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 12:15:14 -0400
Date: Thu, 11 Aug 2011 12:04:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [RFC][RFT][PATCH V2 2/2] b43: fix DMA on some bugged hardware
Message-ID: <20110811160424.GC2566@tuxdriver.com> (sfid-20110811_181524_983419_55C39C37)
References: <1313001339-11211-1-git-send-email-zajec5@gmail.com>
 <1313001339-11211-2-git-send-email-zajec5@gmail.com>
 <CACna6rynj+OXL1R6jwgnCzReuO+=piOX3LTC9UujDTg4DNBVUw@mail.gmail.com>
 <4E435D0E.80702@lwfinger.net>
 <CACna6rxtkq7QGm52aunVZnqY48uO4+FL18S4kpuvYax55TePZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rxtkq7QGm52aunVZnqY48uO4+FL18S4kpuvYax55TePZQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 11, 2011 at 10:05:19AM +0200, Rafał Miłecki wrote:
> W dniu 11 sierpnia 2011 06:39 użytkownik Larry Finger
> <Larry.Finger@lwfinger.net> napisał:
> > On 08/10/2011 07:14 PM, Rafał Miłecki wrote:
> >>
> >> W dniu 10 sierpnia 2011 20:35 użytkownik Rafał Miłecki
> >> <zajec5@gmail.com>  napisał:
> >>>
> >>> Some hardware with 64-bit DMA uses lower address word for setting
> >>> routing (translation) bit. Add workaround for such boards.
> >>>
> >>> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> >>> ---
> >>> This requires testing on at least 1 normal 64-bit DMA card and 1 32-bit
> >>> DMA card. So far it was tested only on my 14e4:4329 where it fixed DMA.
> >>
> >> 14e4:4353 (BCM43224), 64-bit DMA, still works :)
> >>
> >> The rest will follow tomorrow.
> >
> > Tested with 14e4:4311 (64-bit) and 14e4:4318 (32-bit). The ssb changes were
> > also tested with b43legacy.
> 
> Thanks Larry.
> 
> I've additionally tested this on 14e4:4312 (BCM4311), 32-bit DMA. Works OK.
> 
> John: please take this patchset.

Are these fixes intended for 3.1?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
