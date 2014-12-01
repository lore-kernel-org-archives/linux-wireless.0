Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbaLAQMk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 11:12:40 -0500
Date: Mon, 1 Dec 2014 17:12:39 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v6 3/4] cfg80211: return private regdom for
	self-managed devices
Message-ID: <20141201161239.GF25677@wotan.suse.de> (sfid-20141201_171245_241464_5A8C695E)
References: <1417448927-9337-1-git-send-email-arik@wizery.com> <1417448927-9337-3-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417448927-9337-3-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2014 at 05:48:46PM +0200, Arik Nemtsov wrote:
> If a device has self-managed regulatory, insist on returning the wiphy
> specific regdomain if a wiphy-idx is specified. The global regdomain is
> meaningless for such devices.
> 
> Also add an attribute for self-managed devices, so usermode can
> distinguish them as such.
> 
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>

If you add the other hunk here:

Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>

Thanks for all the great work!

  Luis
