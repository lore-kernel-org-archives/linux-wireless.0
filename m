Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41942 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932091Ab0KJWtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 17:49:17 -0500
Message-ID: <4CDB216B.5050704@openwrt.org>
Date: Wed, 10 Nov 2010 23:49:15 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vivek Natarajan <vnatarajan@atheros.com>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] compat/ath9k: pm-qos params patch
References: <1289382968-4165-1-git-send-email-vnatarajan@atheros.com>
In-Reply-To: <1289382968-4165-1-git-send-email-vnatarajan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-11-10 10:56 AM, Vivek Natarajan wrote:
> This patch is similar to the one for ipw2x00:
> This patch is required because now pm-qos has 3 different flavors:
> 
> On kernels >= 2.6.36 the pm qos req is kzalloc()'d by pm-qos itself
> On kernel   = 2.6.35 the pm qos req uses the stack
> On kernels <  2.6.35 the pm qos req is pegged to a unique name.
> 
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> ---
> Rebased on top of my recent patch:
> ath9k: Remove pm_qos request after hw unregister.
I just posted a less intrusive backport for pm_qos that does not require
patching.

- Felix
