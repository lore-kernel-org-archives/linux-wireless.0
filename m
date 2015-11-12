Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53564 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbbKLRrK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 12:47:10 -0500
Message-ID: <1447350423.2131.2.camel@sipsolutions.net> (sfid-20151112_184734_176276_3EED3C35)
Subject: Re: [PATCH] cfg80211: add VHT support for Mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Nov 2015 18:47:03 +0100
In-Reply-To: <1447349791-3849-1-git-send-email-poh@qca.qualcomm.com>
References: <1447349791-3849-1-git-send-email-poh@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-12 at 09:36 -0800, Peter Oh wrote:
> Add NL80211_EXT_FEATURE_VHT_MESH flag to allow drivers
> to indicate support for VHT in Mesh mode.
> 
I'm confused. Why would it be needed? You haven't added any API or
anything where userspace would do something differently based on
whether or not it's supported? There's nothing checking the flag, so
where's the point?

johannes
