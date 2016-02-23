Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60654 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471AbcBWNHx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 08:07:53 -0500
Message-ID: <1456232871.9910.5.camel@sipsolutions.net> (sfid-20160223_140756_142926_9F59D1F7)
Subject: Re: [PATCH RESEND] mac80211: parse VHT info in injected frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 23 Feb 2016 14:07:51 +0100
In-Reply-To: <1456225918-21256-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20160223_121202_626430_9D4DA1ED)
References: <1456225918-21256-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 (sfid-20160223_121202_626430_9D4DA1ED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-02-23 at 12:11 +0100, Lorenzo Bianconi wrote:
> Add VHT radiotap parsing support to ieee80211_parse_tx_radiotap().
> That capability has been tested using a d-link dir-860l rev b1
> running OpenWrt trunk and mt76 driver
> 
> +   VHT rate for the transmission (only for devices without own rate
> control).
> +   Also some flags are parsed
> +
> +   IEEE80211_TX_RC_SHORT_GI: use short guard interval
> +   IEEE80211_TX_RC_40_MHZ_WIDTH: send in HT40 mode
> +   IEEE80211_TX_RC_80_MHZ_WIDTH: send in HT80 mode
> +   IEEE80211_TX_RC_160_MHZ_WIDTH: send in HT160 mode
> 
Wait, I think we somehow confused each other? I thought you were going
to resend with the *_RADIOTAP_* flags here.

johannes
