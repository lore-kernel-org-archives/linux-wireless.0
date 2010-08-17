Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.freeserve.com ([193.252.22.151]:19502 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753537Ab0HQAO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 20:14:59 -0400
Date: Tue, 17 Aug 2010 01:14:55 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [RFT] BCM4312 users with DMA errors, please test!
Message-ID: <20100817011455.4919cfbb@boulder.homenet>
In-Reply-To: <20100817010923.589d8063@boulder.homenet>
References: <AANLkTimMhW7OX3DT7A3EDNaOnr577KmTv5w9C_mz19TG@mail.gmail.com>
	<20100816204154.5100b604@boulder.homenet>
	<20100816233544.40f0e1d4@boulder.homenet>
	<4C69CF85.2020809@lwfinger.net>
	<20100817010923.589d8063@boulder.homenet>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 17 Aug 2010 01:09:23 +0100
Chris Vine <chris@cvine.freeserve.co.uk> wrote:

> On Mon, 16 Aug 2010 18:53:41 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > I tried to duplicate your boot problems without anything unexpected
> > happening.
> > 
> > I don't know what happened, but I doubt that this ssb patch was
> > responsible.
> 
> I have reproduced it twice.  It is definitely the patch, in the sense
> that it happens with the patch included (on two separate tests that I
> have conducted) and never without.
> 
> I do not doubt that you do not experience this effect.  However, you
> don't experience the DMA bug either.

Out of interest, which version of the wl module do you have installed,
as I wonder if that makes a difference?   (As I said in my e-mail on
this, this problem only occurs if the wl module is available to the
kernel.)

Chris


