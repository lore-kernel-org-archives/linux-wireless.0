Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43484 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1HYHfu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 03:35:50 -0400
Received: by gya6 with SMTP id 6so1521665gya.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 00:35:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110810205556.GA3821@jouni.qca.qualcomm.com>
References: <20110810205556.GA3821@jouni.qca.qualcomm.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 25 Aug 2011 10:35:35 +0300
Message-ID: <CA+XVXfcEpEWqq8Hi-gskkiZnSSwFNQebpMheerp71Gq5B71VMg@mail.gmail.com> (sfid-20110825_093553_741216_990A5CEC)
Subject: Re: [PATCH 3/3] nl80211/cfg80211: Add extra IE configuration to AP
 mode setup
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 10, 2011 at 23:55, Jouni Malinen <jouni@qca.qualcomm.com> wrote:
> The NL80211_CMD_NEW_BEACON command is, in practice, requesting AP mode
> operations to be started. Add new attributes to provide extra IEs
> (e.g., WPS IE, P2P IE) for drivers that build Beacon, Probe Response,
> and (Re)Association Response frames internally (likely in firmware).
>
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>

I noticed hostap.git doesn't make use of the new attributes. Are
patches in the works for the usermode parts?
The same applies to NL80211_ATTR_HIDDEN_SSID which was introduced
earlier in this series.

Thanks,
Arik
