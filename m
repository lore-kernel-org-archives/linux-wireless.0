Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36265 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbaJTJsD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:48:03 -0400
Message-ID: <1413798473.10246.13.camel@jlt4.sipsolutions.net> (sfid-20141020_114807_591963_A2739BED)
Subject: Re: [PATCH 2/2] cfg80211: Specify frame and reason code for
 NL80211_CMD_DEL_STATION
From: Johannes Berg <johannes@sipsolutions.net>
To: "Malinen, Jouni" <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 20 Oct 2014 11:47:53 +0200
In-Reply-To: <D062B86A.43EB2%jouni@qca.qualcomm.com>
References: <20141010175525.GA29436@jouni.qca.qualcomm.com>
	 <1413278472.2455.3.camel@jlt4.sipsolutions.net>
	 <D062B86A.43EB2%jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-14 at 10:01 +0000, Malinen, Jouni wrote:

> I think I would be fine with cfg80211 default being Deauthentication frame
> with reason code 2, so if that is what you would like to see here (rather
> than leaving this to the drivers), I can update the patch to behave in
> that way.

As discussed in Duesseldorf, please do so.

johannes

