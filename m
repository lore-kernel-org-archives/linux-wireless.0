Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16391 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303Ab2COIl6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 04:41:58 -0400
Date: Thu, 15 Mar 2012 14:12:19 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	Bing Zhao <bzhao@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3.5] cfg80211: enforce lack of interface combinations
Message-ID: <20120315084217.GA17590@vasanth-laptop> (sfid-20120315_094207_672121_D1F86C46)
References: <20120313150613.300612962@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120313150613.300612962@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 13, 2012 at 04:06:03PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> My grand plan to allow drivers to gradually move over
> to advertising virtual interface combinations and only
> enforce with drivers that do want it enforced doesn't
> seem to be working out, only Christian ever added the
> advertising (to carl9170), nobody else did.
> 
> Begin enforcing combinations in cfg80211 so that users
> can rely on the information reported about a device.

This breaks ath6kl AP mode and P2P, is it expected that the driver
needs to register the combination (?) even it supports a single
interface?

Vasanth
