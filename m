Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44956 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbaLAQNr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 11:13:47 -0500
Date: Mon, 1 Dec 2014 17:13:46 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v6 4/4] cfg80211: correctly check ad-hoc channels
Message-ID: <20141201161346.GG25677@wotan.suse.de> (sfid-20141201_171351_525705_61F8DCCE)
References: <1417448927-9337-1-git-send-email-arik@wizery.com> <1417448927-9337-4-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417448927-9337-4-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2014 at 05:48:47PM +0200, Arik Nemtsov wrote:
> Ad-hoc requires beaconing for regulatory purposes. Validate that the
> channel is valid for beaconing, and not only enabled.
> 
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
