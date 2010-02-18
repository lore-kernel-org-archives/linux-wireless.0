Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:60641 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758532Ab0BRQMe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 11:12:34 -0500
Date: Thu, 18 Feb 2010 08:06:36 -0800
From: Greg KH <greg@kroah.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Frederic Leroy <fredo@starox.org>, linux-wireless@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC PATCH] staging: rtl8192su: remove dead code
Message-ID: <20100218160636.GK21785@kroah.com>
References: <20100217091920.083a3dd3@houba>
 <4B7C1E82.4030005@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B7C1E82.4030005@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2010 at 10:51:14AM -0600, Larry Finger wrote:
> On 02/17/2010 02:19 AM, Frederic Leroy wrote:
> > Hello,
> > 
> > This patch removes some dead code in rtl8192su driver in staging against linux-2.6-stable tree.
> > Should I split it into smaller chunk ? 
> > As it is in staging, should I post it to linux-kernel@vger.kernel.org ?
> 
> At 1400+ lines, the patch is a little large. I would recommend that you separate
> out the fixes for "ifdef RTL8190P" and "ifdef RTL8190U" into one patch, and the
> changes for "ifdef TO_DO_LIST" into a couple of patches. That should get the
> line count to below 500 in the individual patches.

I agree, that would be a better way to do this.

thanks,

greg k-h
