Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab1HXW4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 18:56:48 -0400
Date: Wed, 24 Aug 2011 15:53:57 -0700
From: Greg KH <gregkh@suse.de>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110824225357.GA2224@suse.de> (sfid-20110825_005653_911485_94F02B79)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110824222801.GA5280@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 24, 2011 at 03:28:01PM -0700, Henry Ptasinski wrote:
> With the latest series of cleanup patches merged in by Greg KH, I'd like to
> once again propose moving brcm80211 out of staging and into mainline.
> 
> I've put together a patch to add a copy of the current sources from
> staging-next into wireless-testing:drivers/net/wireless/brcm80211.
> 
> The patch is somewhat large, so I've posted the patch at:
> 
> http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211.patch
> 
> Changes from the previous version:
> 
> V2:
> - Resolve checkpatch issues

Really?  All of them?  What's with all of the use of 'volatile' in the
driver still?  Those should all be resolved as they are all wrong from
what I can see.

Wait, those usages are in your above mentioned patch, but are not in the
current driver in the staging-next tree.  Did you mess up when creating
that patch and take an older version of the driver?

confused,

greg k-h
