Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64079 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab1HHJZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 05:25:17 -0400
Date: Mon, 8 Aug 2011 12:24:48 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] nl80211: Indicate driver-based offchannel TX on
 mgmt_tx_cancel_wait
Message-ID: <20110808092448.GA4876@jouni.qca.qualcomm.com> (sfid-20110808_112520_750033_85CC7E98)
References: <20110808091030.GA4749@jouni.qca.qualcomm.com>
 <1312795335.4372.13.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1312795335.4372.13.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 08, 2011 at 11:22:15AM +0200, Johannes Berg wrote:
> Seems fine to me, I guess the driver in question isn't in the tree yet
> so no need for Cc: stable?

Well, the driver (ath6kl) is, but it does not yet have this
functionality in the main tree, so no need for stable.

-- 
Jouni Malinen                                            PGP id EFC895FA
