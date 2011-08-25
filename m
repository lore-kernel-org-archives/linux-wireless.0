Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7291 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1HYNwM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 09:52:12 -0400
Date: Thu, 25 Aug 2011 14:50:05 +0100
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Arik Nemtsov <arik@wizery.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/3] nl80211/cfg80211: Add extra IE configuration to AP
 mode setup
Message-ID: <20110825135005.GA3764@jouni.qca.qualcomm.com> (sfid-20110825_155215_595230_4123BC68)
References: <20110810205556.GA3821@jouni.qca.qualcomm.com>
 <CA+XVXfcEpEWqq8Hi-gskkiZnSSwFNQebpMheerp71Gq5B71VMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+XVXfcEpEWqq8Hi-gskkiZnSSwFNQebpMheerp71Gq5B71VMg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 10:35:35AM +0300, Arik Nemtsov wrote:
> On Wed, Aug 10, 2011 at 23:55, Jouni Malinen <jouni@qca.qualcomm.com> wrote:
> > The NL80211_CMD_NEW_BEACON command is, in practice, requesting AP mode
> > operations to be started. Add new attributes to provide extra IEs
> > (e.g., WPS IE, P2P IE) for drivers that build Beacon, Probe Response,
> > and (Re)Association Response frames internally (likely in firmware).

> I noticed hostap.git doesn't make use of the new attributes. Are
> patches in the works for the usermode parts?
> The same applies to NL80211_ATTR_HIDDEN_SSID which was introduced
> earlier in this series.

Yes, I did implement matching user space changes with the kernel
patches. I thought I pushed these out before my travel, but apparently
not.. I'll get them out once I get back home and verify which of my
working branches has the latest set ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
