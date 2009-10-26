Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54921 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZJZOqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 10:46:14 -0400
Date: Mon, 26 Oct 2009 10:41:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	Sujith <Sujith.Manoharan@atheros.com>,
	ath9k-devel@lists.ath9k.org
Subject: Re: [RFT 00/15] ath9k_hw ar9271 updates & AR5416 force bias
Message-ID: <20091026144138.GC2792@tuxdriver.com>
References: <1255934026-20686-1-git-send-email-lrodriguez@atheros.com> <43e72e890910212042i6a6a1bc3h1cd2a742f462353f@mail.gmail.com> <43e72e890910260719j508670a8p87bb7a5cf31d843d@mail.gmail.com> <43e72e890910260723o58ad4635g4f6bebfa28f673bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890910260723o58ad4635g4f6bebfa28f673bb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 07:23:44AM -0700, Luis R. Rodriguez wrote:
> On Mon, Oct 26, 2009 at 7:19 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Wed, Oct 21, 2009 at 8:42 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> >> On Mon, Oct 19, 2009 at 3:33 PM, Luis R. Rodriguez
> >> <lrodriguez@atheros.com> wrote:
> >>> This series started off to extend support for ar9271 on ath9k_hw
> >>> but after review of the phy related code I noticed a fix for
> >>> AR5416 was only partially being implemented and used for all
> >>> chipsets. This series then adds the changes I've noticed so far
> >>> required for ar9271 but also fixes and completes the orientation
> >>> fix for AR5416 (force bias). Since I'm touching phy.c I also extend
> >>> documentation for it.
> >>>
> >>> I don't have AR9285 cards with me but I do have an AR5416 cardbus
> >>> card -- I'd appreciate it if someone can give this a test on AR9285
> >
> > Alright well I made it back to California and tested an AR9285 and
> > things are peachy so I will submit this now.
> 
> Johh, actually instead of resubmitting can you take these in as-is?
> They should apply on top of the latest tree. Please let me know.

I'm a little buried ATM, but sure -- that'll be fine...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
