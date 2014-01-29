Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbaA2MLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 07:11:07 -0500
Message-ID: <1390997455.4143.5.camel@jlt4.sipsolutions.net> (sfid-20140129_131112_961767_42774948)
Subject: Re: [PATCH RESEND mac80211] cfg80211: fix channel configuration in
 IBSS join
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Antonio Quartulli <antonio@open-mesh.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	Bing Zhao <bzhao@marvell.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	libertas-dev@lists.infradead.org
Date: Wed, 29 Jan 2014 13:10:55 +0100
In-Reply-To: <1390913540-2127-1-git-send-email-antonio@meshcoding.com>
References: <1390913540-2127-1-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-28 at 13:52 +0100, Antonio Quartulli wrote:

> When receiving an IBSS_JOINED event select the BSS object
> based on the {bssid, channel} couple rather than the bssid
> only.

Applied. I took it for mac80211-next since that's a rather special case.
I also squashed in the ij.bssid bugfix since it was in that area.

johannes

