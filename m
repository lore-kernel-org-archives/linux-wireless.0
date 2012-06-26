Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36172 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab2FZHdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 03:33:32 -0400
Message-ID: <1340696006.4662.9.camel@jlt3.sipsolutions.net> (sfid-20120626_093335_967671_94C4B6A1)
Subject: Re: [PATCH v4] nl80211: specify RSSI threshold in scheduled scan
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 09:33:26 +0200
In-Reply-To: <1340302194-3760-1-git-send-email-c_tpeder@qca.qualcomm.com>
References: <1340302194-3760-1-git-send-email-c_tpeder@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-21 at 11:09 -0700, Thomas Pedersen wrote:
> Support configuring an RSSI threshold in dBm (s32) when requesting
> scheduled scan, below which a BSS won't be reported by the cfg80211
> driver.

Applied, thanks.

johannes

