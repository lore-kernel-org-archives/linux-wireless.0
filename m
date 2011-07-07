Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1753 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756677Ab1GGPBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 11:01:33 -0400
Date: Thu, 7 Jul 2011 08:01:07 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Pavel Roskin" <proski@gnu.org>
cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [RFC] Move brcm80211 to mainline
Message-ID: <20110707150107.GG23944@broadcom.com> (sfid-20110707_170136_434093_2A4833B7)
References: <20110707002034.GA17885@broadcom.com>
 <4E1501B7.80303@gnu.org>
MIME-Version: 1.0
In-Reply-To: <4E1501B7.80303@gnu.org>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 06, 2011 at 05:45:43PM -0700, Pavel Roskin wrote:
> On 07/06/2011 08:20 PM, Henry Ptasinski wrote:
> > With the latest series of cleanup patches merged in by Greg KH, I'd like to now
> > propose moving brcm80211 out of staging and into mainline.
> >
> > Since brcm80211 in staging-next has about ~250 patches that areen't in
> > wireless-testing yet, I've put together a patch to add a copy of the current
> > sources from staging-next into wireless-testing:drivers/net/wireless/brcm80211.
> >
> > The patch is somewhat large, so I've posted the patch at:
> >
> > 	http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211.patch
> >
> > Only the necessary Kconfig and Makefile adjustments have been made (the sources
> > are unchanged from what's currently in staging-next).
> 
> The change to Kconfig seems to be wrong.  It would be better to respect 
> CONFIG_WLAN in drivers/net/wireless/Kconfig, like all other drivers do. 
>   Then drivers/net/wireless/brcm80211/Kconfig should be cleaned up to 
> remove unneeded dependencies on CONFIG_WLAN.

Definitely.  Thanks for pointing that out.

- Henry


