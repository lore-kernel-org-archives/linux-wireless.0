Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2JJHub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 03:50:31 -0400
Message-ID: <1349855466.4683.27.camel@jlt4.sipsolutions.net> (sfid-20121010_095035_597587_92A3849D)
Subject: Re: [PATCH] mac80211: Use appropriate debug wrapper
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 10 Oct 2012 09:51:06 +0200
In-Reply-To: <1349712227-4955-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1349712227-4955-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-08 at 21:33 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> ieee80211_sta_expire will be called by both IBSS and mesh
> interfaces to account for inactive stations, so it would be more
> appropriate to use sta_dbg instead of ibss_dbg.

Applied, thanks.

johannes


