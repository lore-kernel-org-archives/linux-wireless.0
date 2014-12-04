Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281AbaLDRhh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 12:37:37 -0500
Date: Thu, 4 Dec 2014 18:37:35 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	stable@vger.kernel.org
Subject: Re: [PATCH] cfg80211: avoid mem leak on driver hint set
Message-ID: <20141204173735.GG25677@wotan.suse.de> (sfid-20141204_183740_980137_91943039)
References: <1417688536-9145-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417688536-9145-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 04, 2014 at 12:22:16PM +0200, Arik Nemtsov wrote:
> In the already-set and intersect case of a driver-hint, the previous
> wiphy regdomain was not freed before being reset with a copy of the
> cfg80211 regdomain.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>

Acked-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
