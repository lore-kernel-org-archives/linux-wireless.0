Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20283 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989Ab0KRPJC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 10:09:02 -0500
Subject: Re: [iwlwifi] Change MIMO Bit Rates
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "An (Jack) Chan" <jackachan@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <AANLkTin910W2HofnYpHn7a+g7mS0VQaJoqOq=1JrVXM4@mail.gmail.com>
References: <AANLkTin910W2HofnYpHn7a+g7mS0VQaJoqOq=1JrVXM4@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 18 Nov 2010 07:08:05 -0800
Message-Id: <1290092885.15852.2.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-18 at 07:05 -0800, An (Jack) Chan wrote:
> Dear all,
> 
> From linux-wireless documentation for iw, I find that setting
> preferences for transmitting using MCS rates is not yet supported.
> Does it mean I cannot set different MIMO rate through iw CLI?
> 
> What is the default MIMO bit rate the iwl5000 would use? I setting up
> an ad-hoc connection between two laptops equipped with Intel 5300
> cards with 3 antennas each. I find the bit rate is only 5.5Mbps when I
> use "iw dev ah0 station dump" to check. It seems not a MIMO bit rate.
> 
> Maybe I miss something. Does anyone have any idea?
> 
> Thank you very much.
> 
> Best,
> 

iwlwifi driver does not support 11n in IBSS mode

Wey



