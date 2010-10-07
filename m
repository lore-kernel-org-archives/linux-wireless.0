Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab0JGSPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:15:43 -0400
Subject: Re: Vendor specific data within a beacon frame
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bjoern Czybik <wlfw@gmx.com>, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimTLEShJ3HcBqHaU5U5nFq1UywczC=G7oiHx=as@mail.gmail.com>
References: <4CAD9368.70608@gmx.com>
	 <AANLkTimTLEShJ3HcBqHaU5U5nFq1UywczC=G7oiHx=as@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Oct 2010 20:15:42 +0200
Message-ID: <1286475342.20974.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-10-07 at 11:11 -0700, Luis R. Rodriguez wrote:

Let me quote what you wrote, but just partially:

> This can be done from userspace. This is from nl80211.h:

>  *      Note: This command has been removed and it is only reserved at this
>  *      point to avoid re-using existing command number. The functionality this
>  *      command was planned for has been provided with cleaner design with the
>  *      option to specify additional IEs in NL80211_CMD_TRIGGER_SCAN,
>  *      NL80211_CMD_AUTHENTICATE, NL80211_CMD_ASSOCIATE,
>  *      NL80211_CMD_DEAUTHENTICATE, and NL80211_CMD_DISASSOCIATE.

:P

johannes

