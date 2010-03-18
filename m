Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55020 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0CRUaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 16:30:12 -0400
Date: Thu, 18 Mar 2010 16:20:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: RFC: A workaround for BCM43XX devices with no on-board SPROM
Message-ID: <20100318202052.GD17357@tuxdriver.com>
References: <4BA266FB.1080507@lwfinger.net> <201003182031.25013.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201003182031.25013.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 18, 2010 at 08:31:24PM +0100, Michael Buesch wrote:
> On Thursday 18 March 2010 18:46:35 Larry Finger wrote:

> > It it reasonable to keep the vendor portion of the MAC and only replace the
> > "serial number", or would it be better to randomize all 6 octants?
> 
> I think it doesn't really matter.

It might be a good idea to set the LAA bit...?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
