Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab0KJQAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 11:00:11 -0500
Subject: Re: [PATCHv2] mac80211: Add function to get probe request template
 for current AP
From: Johannes Berg <johannes@sipsolutions.net>
To: juuso.oikarinen@nokia.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1289372616-15378-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1289372616-15378-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 08:01:29 -0800
Message-ID: <1289404889.3748.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-10 at 09:03 +0200, juuso.oikarinen@nokia.com wrote:

> + * .bss_info_changed callback function. The function is only useful in managed
> + * mode while the interface is associated, otherwise it will return NULL.

Since you have a WARN_ON, wouldn't it be more honest to document that
it's invalid to call in other modes?

johannes

