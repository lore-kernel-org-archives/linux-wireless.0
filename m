Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103AbaLASKC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 13:10:02 -0500
Date: Mon, 1 Dec 2014 19:09:59 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v7 1/4] cfg80211: allow usermode to query wiphy
	specific regdom
Message-ID: <20141201180959.GK25677@wotan.suse.de> (sfid-20141201_191007_014782_1CA5839D)
References: <1417451331-20536-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417451331-20536-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2014 at 06:28:48PM +0200, Arik Nemtsov wrote:
> If a wiphy-idx is specified, the kernel will return the wiphy specific
> regdomain, if such exists. Otherwise return the global regdom.
> 
> When no wiphy-idx is specified, return the global regdomain as well as
> all wiphy-specific regulatory domains in the system, via a new nested
> list of attributes.
> 
> Add a new attribute for each wiphy-specific regdomain, for usermode to
> identify it as such.
> 
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
