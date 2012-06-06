Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53089 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2FFIyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 04:54:11 -0400
Message-ID: <1338972850.4513.26.camel@jlt3.sipsolutions.net> (sfid-20120606_105415_083983_31E707E7)
Subject: Re: [RFC 03/14] cfg80211: introduce cfg80211_stop_ap
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 10:54:10 +0200
In-Reply-To: <1338203942-5667-4-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
	 <1338203942-5667-4-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-28 at 13:18 +0200, Michal Kazior wrote:
> This functionality will be reused when interface
> is going down. Avoids code duplication. Also adds
> missing wdev locking.
> 
> Change-Id: I358660cdac652b56eacdd0adae76cc16aa4e4800
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Looks good.

johannes

