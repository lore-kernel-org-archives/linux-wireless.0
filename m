Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43290 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1ATRMH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 12:12:07 -0500
Message-ID: <4D386CE1.3080906@openwrt.org>
Date: Thu, 20 Jan 2011 18:12:01 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k:  Try more than one queue when scheduling new aggregate.
References: <1295400600-20596-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1295400600-20596-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-19 2:30 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Try all xmit queues until the hardware buffers are full.
Acked-by: Felix Fietkau <nbd@openwrt.org>
