Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33456 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbcHAKC1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 06:02:27 -0400
Message-ID: <1470045741.3389.23.camel@sipsolutions.net> (sfid-20160801_120436_784962_097616EF)
Subject: Re: [PATCH v3] cfg80211: Allow different beacon interval if driver
 supports
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
Date: Mon, 01 Aug 2016 12:02:21 +0200
In-Reply-To: <1469180557-24210-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1469180557-24210-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-07-22 at 15:12 +0530, Purushottam Kushwaha wrote:
> Driver may allow support for different beacon interval on virtual
> interfaces.
> Allow if such support is advertised by driver. This adds new
> ext_feature as
> NL80211_EXT_FEATURE_DIFF_BEACON_INTERVAL.
> 
My earlier comment regarding interface combinations still stands.

johannes
