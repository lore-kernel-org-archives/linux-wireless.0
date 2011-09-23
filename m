Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15140 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab1IWHpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 03:45:49 -0400
Message-ID: <4E7C3925.9040807@qca.qualcomm.com> (sfid-20110923_094557_581973_4C403E26)
Date: Fri, 23 Sep 2011 10:45:41 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: pass only unicast frames for aggregation
References: <20110919183844.25296.65533.stgit@localhost6.localdomain6>
In-Reply-To: <20110919183844.25296.65533.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2011 09:38 PM, Kalle Valo wrote:
> When pinging form ar6003 to the AP RTT was high even when power save was
> disabled:
> 
> 100 packets transmitted, 97 received, 3% packet loss, time 99125ms
> rtt min/avg/max/mdev = 1.875/46.733/795.506/139.181 ms
> 
> After some investigation one reason for this was that received
> multicast traffic confused the aggrecation logic and caused 400 ms
> timeouts when receiving multicast frames from AP.
> 
> A simple way to fix is to pass only unicast frames for aggregation. This
> improves RTT:
> 
> 100 packets transmitted, 99 received, 1% packet loss, time 99144ms
> rtt min/avg/max/mdev = 2.083/13.084/403.390/56.794 ms

Applied.

Kalle
