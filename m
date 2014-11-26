Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbaKZVNd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 16:13:33 -0500
Date: Wed, 26 Nov 2014 22:13:32 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v4 1/4] cfg80211: leave invalid channels on regdomain
	change
Message-ID: <20141126211332.GR25677@wotan.suse.de> (sfid-20141126_221336_785828_2E90BDBE)
References: <1417035388-2511-1-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417035388-2511-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2014 at 10:56:25PM +0200, Arik Nemtsov wrote:
> When the regulatory settings change, some channels might become invalid.
> Disconnect interfaces acting on these channels, after giving userspace
> code a grace period to leave them.
> 
> This mode is currently opt-in, and not all interface operating modes are
> supported for regulatory-enforcement checks. A wiphy that wishes to use
> the new enforcement code must specify an appropriate regulatory flag,
> and all its supported interface modes must be supported by the chekcing
> code.

Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>

  Luis
