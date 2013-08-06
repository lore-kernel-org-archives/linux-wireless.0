Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:43460 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab3HFUPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 16:15:11 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: add control port protocol TX control flag
References: <1375783056-2665-1-git-send-email-johannes@sipsolutions.net>
Date: Tue, 06 Aug 2013 23:15:09 +0300
In-Reply-To: <1375783056-2665-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Tue, 6 Aug 2013 11:57:36 +0200")
Message-ID: <87haf2wp82.fsf@purkki.adurom.net> (sfid-20130806_221516_293351_3C88C59C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> A lot of drivers check the frame protocol for ETH_P_PAE,
> for various reasons (like making those more reliable).
> Add a new flags bitmap to the TX control info and a new
> flag indicating the control port protocol is in use to
> let all drivers also apply such logic to other control
> port protocols, should they be configured.
>
> Change-Id: I292ba4865694142670f005856b6320f7f3fa05c8
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

I'm sure you noticed, but there's a Change-Id tag.

-- 
Kalle Valo
