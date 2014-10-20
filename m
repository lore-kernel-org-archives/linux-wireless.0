Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37866 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbaJTOkB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 10:40:01 -0400
Message-ID: <1413815998.24269.2.camel@jlt4.sipsolutions.net> (sfid-20141020_164007_318581_86315E0F)
Subject: Re: [PATCH v2 2/2] cfg80211: Specify frame and reason code for
 NL80211_CMD_DEL_STATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 20 Oct 2014 16:39:58 +0200
In-Reply-To: <20141020102045.GA2716@jouni.qca.qualcomm.com>
References: <20141010175525.GA29436@jouni.qca.qualcomm.com>
	 <1413278472.2455.3.camel@jlt4.sipsolutions.net>
	 <20141020102045.GA2716@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 13:20 +0300, Jouni Malinen wrote:
> The optional NL80211_ATTR_MGMT_SUBTYPE and NL80211_ATTR_REASON_CODE
> attributes can now be included in NL80211_CMD_DEL_STATION to indicate to
> the driver which frame (Deauthentication/Disassociation) and reason code
> in that frame should be used to indicate removal to the specific
> station. This is used by drivers that implement AP SME and generate
> those frames internally.

Applied.

johannes

