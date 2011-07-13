Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:55782 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754502Ab1GMOQH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 10:16:07 -0400
Message-ID: <4E1DA8A6.3060908@gnu.org> (sfid-20110713_161611_858910_38C51D78)
Date: Wed, 13 Jul 2011 10:16:06 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/11] ath5k: remove wireless extensions inclusions
References: <20110713083908.713123063@sipsolutions.net> <20110713084032.538761142@sipsolutions.net>
In-Reply-To: <20110713084032.538761142@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/13/2011 04:39 AM, Johannes Berg wrote:
> From: Johannes Berg<johannes.berg@intel.com>
>
> linux/wireless.h and net/iw_handler.h headers are
> for wireless extensions only, so mac80211 drivers
> shouldn't be including them.
>
> Signed-off-by: Johannes Berg<johannes.berg@intel.com>

Acked-by: Pavel Roskin <proski@gnu.org>

-- 
Regards,
Pavel Roskin
