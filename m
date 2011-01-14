Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34565 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752562Ab1ANTiI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 14:38:08 -0500
Message-ID: <4D30A61E.1020607@openwrt.org>
Date: Fri, 14 Jan 2011 20:38:06 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: preserve caldata history buffer across scanning
References: <1295033482-12257-1-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1295033482-12257-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-14 8:31 PM, Rajkumar Manoharan wrote:
> caldata's channel info is never filled with operating channel
> info which is causing the operating channel's noise floor
> history buffer is reset to default nf during channel change.
>
> Signed-off-by: Rajkumar Manoharan<rmanoharan@atheros.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>
