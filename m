Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55824 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3B1WlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 17:41:20 -0500
Message-ID: <1362091275.8330.13.camel@jlt4.sipsolutions.net> (sfid-20130228_234123_393639_0036F219)
Subject: Re: [PATCHv3] cfg80211: Extend support for IEEE 802.11r Fast BSS
 Transition
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Feb 2013 23:41:15 +0100
In-Reply-To: <20130227151427.GA19980@jouni.qca.qualcomm.com>
References: <20130221060843.GA24491@w1.fi>
	 <1361565394.3420.17.camel@jlt4.sipsolutions.net>
	 <20130226103819.GA5630@jouni.qca.qualcomm.com>
	 <1361910682.8440.7.camel@jlt4.sipsolutions.net>
	 <20130227151427.GA19980@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 17:14 +0200, Jouni Malinen wrote:
> Add NL80211_CMD_UPDATE_FT_IES to support update of FT IEs to the WLAN
> driver and NL80211_CMD_FT_EVENT to send FT events from the WLAN driver.
> This will carry the target AP's MAC address along with the relevant
> Information Elements. This event is used to report received FT IEs
> (MDIE, FTIE, RSN IE, TIE, RICIE). These changes allow FT to be supported
> with drivers that use an internal SME instead of user space option (like
> FT implementation in wpa_supplicant with mac80211-based drivers).

Applied.

johannes

