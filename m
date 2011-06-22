Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758573Ab1FVVY2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 17:24:28 -0400
Subject: Re: [PATCH 1/2] mac80211: propagate information about STA WME
 support down
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1308777573-12257-1-git-send-email-arik@wizery.com> (sfid-20110622_232000_623971_AE72B4EE)
References: <1308777573-12257-1-git-send-email-arik@wizery.com>
	 (sfid-20110622_232000_623971_AE72B4EE)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 23:24:26 +0200
Message-ID: <1308777866.29571.32.camel@jlt3.sipsolutions.net> (sfid-20110622_232431_543622_2630A407)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-23 at 00:19 +0300, Arik Nemtsov wrote:
> Add a memeber to the ieee80211_sta structure to indicate whether the STA
> supports WME.

> + * @wme: indicates whether the STA supports WME

You should probably update that also in other modes (when this is a
station representing an AP) for consistency. If that's really tough you
could document that it's only valid if the interface is in AP mode, but
I guess I'd prefer just having it valid.

johannes

