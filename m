Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab0K2QvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 11:51:03 -0500
Subject: Re: [PATCH 2/2 v3] mac80211: add throughput based LED blink trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1291047211.26829.17.camel@wwguy-ubuntu>
References: <1290884614.3700.3.camel@jlt3.sipsolutions.net>
	 <1290885648.3700.4.camel@jlt3.sipsolutions.net>
	 <1290947171.3467.7.camel@jlt3.sipsolutions.net>
	 <1291047211.26829.17.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 17:50:58 +0100
Message-ID: <1291049458.3532.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-29 at 08:13 -0800, Guy, Wey-Yi wrote:

> Do not see how it work for different hardware has different requirement,
> for example, in iwlwifi, different device has different blink time
> compensation.

Well you haven't seen the iwlwifi patch for it yet :-)

Blink compensation is applied to the values. So if the trigger says
"blink for 167ms on and 167ms off", blink compensation will be applied
to the value 167.

johannes

