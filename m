Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from waste.org ([66.93.16.53]:59482 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932334AbXCUUfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 16:35:00 -0400
Date: Wed, 21 Mar 2007 15:22:25 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
Message-ID: <20070321202225.GN10459@waste.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org> <1174433034.62033.16.camel@localhost> <20070320223643.d8cbc3f6.akpm@linux-foundation.org> <4601761F.4000302@lwfinger.net> <20070321185900.GC3801@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070321185900.GC3801@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the latest -mm, I'm now getting this:

Mar 21 15:06:52 cinder kernel: ipw2200: Detected Intel PRO/Wireless
2200BG Network Connection
Mar 21 15:06:52 cinder kernel: firmware_loading_store: unexpected
value (0)
Mar 21 15:06:52 cinder kernel: ipw2200: ipw2200-bss.fw
request_firmware failed:
Reason -2
Mar 21 15:06:52 cinder kernel: ipw2200: Unable to load firmware: -2
Mar 21 15:06:52 cinder kernel: ipw2200: failed to register network
device

-- 
Mathematics is the supreme nostalgia of our time.
