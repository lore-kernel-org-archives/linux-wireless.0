Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0LQJtG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 04:49:06 -0500
Subject: Re: [RFC 2/8] cfg80211: process new country regulatory flags (DFS)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292556197-4820-3-git-send-email-lrodriguez@atheros.com>
References: <1292556197-4820-1-git-send-email-lrodriguez@atheros.com>
	 <1292556197-4820-3-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Dec 2010 10:49:03 +0100
Message-ID: <1292579343.3715.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 19:23 -0800, Luis R. Rodriguez wrote:

> + * @NL80211_ATTR_REG_COUNTRY_FLAGS: Country specific regulatory flags.
> + *	These are @NL80211_CFLAG_DFS_FCC_*

How many FCCs are there? ;-)
 
johannes

