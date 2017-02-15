Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56224 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750800AbdBOH4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 02:56:55 -0500
Message-ID: <1487145412.4026.5.camel@sipsolutions.net> (sfid-20170215_085658_832512_0DABCBC7)
Subject: Re: [PATCH v3 2/2] mac80211: store tx power value from user to
 station
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, arnagara@codeaurora.org
Date: Wed, 15 Feb 2017 08:56:52 +0100
In-Reply-To: <1486555011-25143-1-git-send-email-arnagara@qti.qualcomm.com>
References: <1486555011-25143-1-git-send-email-arnagara@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + * @txpwr: indicates the tx power, in mBm, to be used when sending data frames
+ *	to the STA. Value of 0 means, automatic (default) tx power.

Similarly here, I'm not too sure about 0 meaning automatic.

johannes
