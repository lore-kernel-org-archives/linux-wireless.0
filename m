Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bredband2.net ([82.209.166.4]:14319 "EHLO
	smtp.bredband2.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751676AbYIIFjo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 01:39:44 -0400
Date: Tue, 9 Sep 2008 07:33:00 +0200
From: Mats Johannesson <spamcan1@abrasax.se>
To: linux-wireless@vger.kernel.org, marcel@holtmann.org,
	vasanth@atheros.com, johannes@sipsolutions.net
Subject: Re: [PATCH] Ath9k: Add RF kill support.
Message-ID: <20080909073300.64ad5f27@loke.fish.not> (sfid-20080909_073959_084809_C8BDBF14)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2008 at 10:52:20AM +0530, Marcel Holtmann wrote:
And Vasanthakumar Thiagarajan replied:
[...]
> > > Normally home users may not hit a situation where they have to
> > > disable the radio, so they can compile out the rf kill support
> > > and essentially disable the periodic run of the work queue
> > > (rfkill_poll ,runs for every 2 secs).If this does not make
> > > any sense, I will remove this config option.
[...]
> > The desktop use case needs RFKILL support, because that will be used
> > for switching off the radio. Just think about the flight mode case.
> > So the only case where disabling RFKILL support makes sense would be
> > an embedded system with specific constraints. However even in the
> > embedded case, I don't see that usefulness.
> >
> Yeah, I understand.

My 'rfkill' solution is to pull the PCCard out of the notebook slot!
Please, make it configurable. I don't want useless code running in my
sleek kernel (especially polling code...)

Mvh
Mats Johannesson
