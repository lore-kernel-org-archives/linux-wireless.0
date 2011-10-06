Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab1JFSS5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 14:18:57 -0400
Date: Thu, 6 Oct 2011 11:18:40 -0700
From: Greg KH <gregkh@suse.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Alwin Beukers <alwin@broadcom.com>
Subject: Re: [PATCH v3] move brcm80211 drivers to mainline
Message-ID: <20111006181840.GA18304@suse.de> (sfid-20111006_201900_505218_622CF471)
References: <4E8C64EF.3070203@broadcom.com>
 <20111005142402.GC17286@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111005142402.GC17286@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 05, 2011 at 10:24:03AM -0400, John W. Linville wrote:
> On Wed, Oct 05, 2011 at 04:08:47PM +0200, Arend van Spriel wrote:
> > With number of cleanup patch series merged in by Greg KH, I'd like to
> > once again propose moving brcm80211 out of staging and into mainline.
> > 
> > I've put together a patch to add a copy of the current sources from
> > staging-next into drivers/net/wireless/brcm80211 of the wireless-next
> > repository.
> > 
> > The patch is somewhat large, so I've posted the patch at:
> > 
> > http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=view&target=0001-net-wireless-add-brcm80211-drivers-v3.patch
> 
> Feel free to complain, but I plan to merge this in time for the merge
> window unless someone identifies a true "showstopper" problem with
> this patch in the next day or so.

I have no objection to this, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the merge patch.

greg k-h
