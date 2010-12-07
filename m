Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56376 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab0LGVpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:45:39 -0500
Subject: Re: [PATCH 1/2] cfg80211: add some element IDs in enum
 ieee80211_eid
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1291758184-649-1-git-send-email-bzhao@marvell.com>
References: <1291758184-649-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 22:45:36 +0100
Message-ID: <1291758336.3607.62.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-07 at 13:43 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> 1)WLAN_EID_BSS_COEX_2040
> 2)WLAN_EID_OVERLAP_BSS_SCAN_PARAM
> 3)WLAN_EID_EXT_CAPABILITY
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>

I believe this patch can go in regardless of mwifiex status.

johannes

