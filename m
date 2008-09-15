Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39837 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957AbYIORBu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 13:01:50 -0400
Date: Mon, 15 Sep 2008 10:01:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: fix static regdomains
Message-ID: <20080915170137.GD22572@tesla> (sfid-20080915_190207_373982_8206CEF2)
References: <1221467435.3700.27.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1221467435.3700.27.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 15, 2008 at 01:30:34AM -0700, Johannes Berg wrote:
> When Luis added the static regdomains back he used +/-20
> of the centre frequencies to account for 40MHz bandwidth
> neglecting the fact that 40MHz bandwidth cannot be used
> on the channels close to the allowed band edges.

Good catch, not sure exactly where this applies but since
the static stuff will die soon sure, its better to be safe.

  Luis
