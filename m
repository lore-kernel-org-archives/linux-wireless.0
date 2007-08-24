Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:51548 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbXHXTdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 15:33:23 -0400
Message-ID: <46CF327F.4050002@lwfinger.net>
Date: Fri, 24 Aug 2007 14:33:19 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/15] mac80211: remove HW_KEY_IDX_INVALID
References: <20070824122705.549190000@sipsolutions.net> <20070824122905.350213000@sipsolutions.net>
In-Reply-To: <20070824122905.350213000@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

This patch breaks software encryption in my tests - WPA for b43, WPA and WEP for b43legacy. I 
haven't looked for the cause yet. That is my next step.

Larry
