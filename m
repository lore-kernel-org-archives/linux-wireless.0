Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753543AbYJATGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 15:06:43 -0400
Date: Wed, 1 Oct 2008 11:53:52 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	"kaszak@gmail.com" <kaszak@gmail.com>,
	"lcostantino@gmail.com" <lcostantino@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: w35und wifi driver for linux-staging
Message-ID: <20081001185352.GA15713@kroah.com> (sfid-20081001_210650_860109_BAFF953B)
References: <20081001123656.GA30942@elf.ucw.cz> <20081001113458.GC6126@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081001113458.GC6126@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 01, 2008 at 04:34:58AM -0700, Luis R. Rodriguez wrote:
> Please install sparse and then compile the driver using C=1, and correct
> the warnings.
> 
> Ok well that should take a while..

Heh, in the mean time, I'll suck it into drivers/staging/, moving the
files around so that it is self-contained and remove the extra crud and
fix up the build stuff so that it plays nice with the rest of the
kernel.

I'll post the updated patch when it goes into my tree.

thanks,

greg k-h
