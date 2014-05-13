Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39435 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaEMSjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 14:39:12 -0400
Message-ID: <1400006337.4137.28.camel@jlt4.sipsolutions.net> (sfid-20140513_203915_380977_471CF6AF)
Subject: Re: [PATCH 3.15] nl80211: fix
 NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL API
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 May 2014 20:38:57 +0200
In-Reply-To: <20140513173959.GF21204@tuxdriver.com>
References: <1399988848-13185-1-git-send-email-johannes@sipsolutions.net>
	 <20140513173959.GF21204@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-13 at 13:39 -0400, John W. Linville wrote:
> Do we need to preserve the API compatibility?

Well, yes. Even iw uses this, and compiling it fails without it.

johannes

