Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39759 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbbDXKX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2015 06:23:59 -0400
Message-ID: <1429871032.1852.26.camel@sipsolutions.net> (sfid-20150424_122403_416157_1B924268)
Subject: Re: [PATCH] mac80211: fix ignored HT/VHT override configs
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Date: Fri, 24 Apr 2015 12:23:52 +0200
In-Reply-To: <1429559506-22853-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1429559506-22853-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-04-20 at 22:51 +0300, Emmanuel Grumbach wrote:
> From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
> 
> HT and VHT override configurations were ignored during association and
> applied only when first beacon recived, or not applied at all.
> 
> Fix the code to apply HT/VHT overrides during association. This is a bit
> tricky since the channel was already configured during authentication
> and we don't want to reconfigure it unless there's really a change.

Applied.

johannes

