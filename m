Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:44289 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756692AbZAOTD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 14:03:28 -0500
Date: Thu, 15 Jan 2009 10:49:55 -0800
From: Greg KH <greg@kroah.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: darklight <darklight.xdarklight@googlemail.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] ath5k: ignore the return value of
	ath5k_hw_noise_floor_calibration
Message-ID: <20090115184955.GG10674@kroah.com> (sfid-20090115_200334_574587_260F429C)
References: <888a464d0901091721l6657e755vbfe5bae0367f6413@mail.gmail.com> <b6c5339f0901101515q48703b16o82d7550492dd34a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0901101515q48703b16o82d7550492dd34a5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 10, 2009 at 06:15:01PM -0500, Bob Copeland wrote:
> On Fri, Jan 9, 2009 at 8:21 PM, darklight
> <darklight.xdarklight@googlemail.com> wrote:
> > hi,
> >
> > some weeks ago Felix Fietkau posted a patch for the "ath5k phy0:
> > unsupported jumbo" warnings (see here:
> > http://article.gmane.org/gmane.linux.kernel.wireless.general/23430 )
> > I just had the same problem - after applying Felix' patch the warnings
> > went down from 50-100 per day to 5.
> 
> It's already in Linus' tree for 2.6.29 (CCed stable@kernel.org).
> 
> Greg / stable, can you take 8b0162a3dc5c30e862b7a73da29e32de3170f5e4 for
> 2.6.28.X?
> 
> (It's not unsupported jumbo warnings, it's for noise floor calibration
> failures, as in the subject of this email.)

Now queued up, thanks.

greg k-h
