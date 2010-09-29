Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:28796 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab0I2G2f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 02:28:35 -0400
Subject: Re: [PATCH 0/2] wl1271: Packet aggregation optimizations
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Ido Yariv <ido@wizery.com>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285686464-8668-1-git-send-email-ido@wizery.com>
References: <1285686464-8668-1-git-send-email-ido@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 09:28:04 +0300
Message-ID: <1285741684.11177.98.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 17:07 +0200, ext Ido Yariv wrote:
> The WL1271 HW supports sending and receiving multiple packets within
> a single transaction. This can substantially reduce CPU usage and
> increase network throughput.
> 
> The following patches add support for RX and TX packet aggregation.
> An opportunistic approach was taken - all packets that are currently
> available for sending/receiving are aggregated and transferred
> in a single transaction.
> 
> The patches were tested on a Zoom2 platform (SDIO only).
> 
> Ido Yariv (2):
>   wl1271: Support firmware RX packet aggregation
>   wl1271: Support firmware TX packet aggregation
> 

Thanks for these patches! 

We are testing them now.

-Juuso

