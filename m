Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:50273 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142Ab0GAT7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 15:59:39 -0400
Message-ID: <4C2CF3A9.1090408@openwrt.org>
Date: Thu, 01 Jul 2010 21:59:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: tom.leiming@gmail.com
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] minstrel_ht: fix check for downgrading of top2 rate
References: <1277997590-3512-1-git-send-email-tom.leiming@gmail.com>
In-Reply-To: <1277997590-3512-1-git-send-email-tom.leiming@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-01 5:19 PM, tom.leiming@gmail.com wrote:
> From: Ming Lei <tom.leiming@gmail.com>
> 
> The check should be against current top2 rate, instead of
> current top rate.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>
