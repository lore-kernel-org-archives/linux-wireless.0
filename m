Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46724 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752820AbdCFMXV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 07:23:21 -0500
Message-ID: <1488802976.5761.4.camel@sipsolutions.net> (sfid-20170306_132325_612361_849C24A5)
Subject: Re: [PATCH] mac80211_hwsim: Add channel 169 (5845 MHz)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Mar 2017 13:22:56 +0100
In-Reply-To: <1488794166-26903-1-git-send-email-jouni@qca.qualcomm.com>
References: <1488794166-26903-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-03-06 at 11:56 +0200, Jouni Malinen wrote:
> This channel is defined in the IEEE 802.11 standard and available in
> number of countries, so extend the mac80211_hwsim channel list to
> cover
> channel 169 to enable additional testing.

Makes sense, applied.

johannes
