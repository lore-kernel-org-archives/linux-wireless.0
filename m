Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55968 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbZBDOpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 09:45:55 -0500
Date: Wed, 4 Feb 2009 09:43:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Jason Andryuk <jandryuk@gmail.com>, gregkh@suse.de,
	linux-wireless@vger.kernel.org, kalle.valo@iki.fi,
	milan.plzik@gmail.com
Subject: Re: at76_usb development
Message-ID: <20090204144317.GA3845@tuxdriver.com> (sfid-20090204_154559_374118_D4BA6677)
References: <c4d76b3b0902032005m3847235cu42f963ca6ad796af@mail.gmail.com> <200902040917.14343.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200902040917.14343.oliver@neukum.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 04, 2009 at 09:17:12AM +0100, Oliver Neukum wrote:
> Am Wednesday 04 February 2009 05:05:04 schrieb Jason Andryuk:
> > Where should development on at76_usb take place?
> [..]
> > I have more or less tracked down an Oops on disconnect with the
> > wireless-testing version.  Hopefully the time spent has been
> > worthwhile.
> > 
> > Let me know,
> 
> This is an important question. We cannot develop against widely
> diverging versions. If the driver is changed a lot, development must happen
> against the kernel version or it should be removed from the kernel.

AFAIK you should be sending patches to Greg against the version in
drivers/staging.  Kalle may want to be copied.

FWIW, I haven't seen the revised driver that Kalle is developing.
Hopefully we will see that before too long.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
