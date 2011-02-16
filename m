Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52046 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758508Ab1BPBvY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 20:51:24 -0500
Date: Tue, 15 Feb 2011 20:50:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: kernel@fomichev.me, Greg Korah-Hartman <gregkh@suse.de>,
	devel@linuxdriverproject.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>
Subject: Re: [PATCH v2 1/4] brcm80211: fix compile issue
Message-ID: <20110216015040.GA2349@tuxdriver.com>
References: <1297721111-20606-1-git-send-email-kernel@fomichev.me>
 <7A94256FD72B884D9E7C55586C3CBCEE13CDA25D88@SJEXCHCCR01.corp.ad.broadcom.com>
 <20110215221200.GA2087@sdf-MacBook>
 <4D5B0034.3090303@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4D5B0034.3090303@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 02:37:40PM -0800, Henry Ptasinski wrote:
> On 02/15/2011 02:12 PM, Stanislav Fomichev wrote:
> >Commit 59eb21a65047 "cfg80211: Extend channel to frequency mapping for 802.11j"
> >changed the definition of the ieee80211_channel_to_frequency; so fix its
> >usage in brcmfmac.
> >
> 
> Commit 59eb21a65047 went into wireless-next a few weeks ago, but
> hasn't made it over to staging-next yet.  Should John pick up this
> patch for wireless-next now, and it'll eventually migrate over to
> staging-next?

If so, not only let me know but also resend a copy to me -- I haven't
been tracking these...

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
