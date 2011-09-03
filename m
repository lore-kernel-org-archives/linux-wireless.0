Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37621 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab1ICKvN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 06:51:13 -0400
Message-ID: <4E62069A.30403@openwrt.org> (sfid-20110903_125116_757641_E8AFD558)
Date: Sat, 03 Sep 2011 12:51:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [RESEND][PATCH] minstrel_ht: fix Open BA session request floods
References: <201109030906.21009.chunkeey@googlemail.com>
In-Reply-To: <201109030906.21009.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-03 9:06 AM, Christian Lamparter wrote:
> Minstrel HT tries very hard to establish a BA session with
> each peer once there's some data on the way. However the
> stack does not inform minstrel if an aggregation session
> is already in place, so it keeps trying and wastes good
> cycles in the tx status path.
>
> [ 8149.946393] Open BA session requested for $AP tid 0
> [ 8150.048765] Open BA session requested for $AP tid 0
> [ 8150.174509] Open BA session requested for $AP tid 0
> [ 8150.274376] Open BA session requested for $AP tid 0
> ...
>
> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>
