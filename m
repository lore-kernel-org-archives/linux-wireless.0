Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:58876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab0IHJFO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 05:05:14 -0400
Date: Wed, 8 Sep 2010 02:05:38 -0700
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <vmehta@atheros.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: ath6kl: Replacing the symbolic link to the
	hw.0 directory with a new directory 'hw' while retaining the
	contents. This will help with the cases where the driver fails to
	compile if the link was not setup properly.
Message-ID: <20100908090538.GA21218@kroah.com>
References: <1283905487-1471-1-git-send-email-vmehta@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283905487-1471-1-git-send-email-vmehta@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 07, 2010 at 05:24:47PM -0700, Vipin Mehta wrote:
> Signed-off-by: Vipin Mehta <vmehta@atheros.com>

What's with the long Subject: ?

Anyway, this patch fails to apply, it seems you want to just delete the
symlink, which you might need to tell git that you want to generate a
patch that does this.  For how you do that, I don't really know, sorry.

If you want, just send a patch that does the proper thing for the
existing files to get everything to build correctly, and then tell me to
remove the symlink by hand, which I can do.  That might be the easiest
thing to do here.

thanks,

greg k-h
