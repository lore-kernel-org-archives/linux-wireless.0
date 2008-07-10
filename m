Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55569 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927AbYGJNU3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 09:20:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix struct ieee80211_tx_queue_params
Date: Thu, 10 Jul 2008 15:20:06 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1215681751.3932.14.camel@johannes.berg>
In-Reply-To: <1215681751.3932.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807101520.06214.mb@bu3sch.de> (sfid-20080710_152033_008320_527E5444)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 July 2008 11:22:31 Johannes Berg wrote:
> Multiple issues:
>  - there are no "default" values needed
>  - cw_min/cw_max can be larger than documented
>  - restructure to decrease size
>  - use get_unaligned_le16

b43 should also be fixed to not check for these "default" magics
anymore. I can do a patch later.

-- 
Greetings Michael.
