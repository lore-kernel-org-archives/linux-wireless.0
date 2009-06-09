Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbZFIAuy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 20:50:54 -0400
Date: Mon, 8 Jun 2009 17:45:32 -0700
From: Greg KH <gregkh@suse.de>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] Staging: stlc45xx: sync with gitorious git tree
Message-ID: <20090609004532.GA22830@suse.de>
References: <20090608190901.25081.26264.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090608190901.25081.26264.stgit@tikku>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 08, 2009 at 10:09:01PM +0300, Kalle Valo wrote:
> From: Kalle Valo <kalle.valo@nokia.com>
> 
> Sync up with stlc45xx repository in gitorious.org from commit
> bb8675d6e59c34b43618970d37d56d724a5e3d96.

Hm, any reason you smushed 23 patches down into 3?  In doing so you lost
some good information, and some authorship information as well, which is
not acceptable.

So care to send me the 23 patches instead, with the proper authorship
information?

And why is development for this driver being done outside the kernel
tree now that is in it?

thanks,

greg k-h
