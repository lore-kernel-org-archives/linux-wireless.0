Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38751 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308Ab0BXEzp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 23:55:45 -0500
Received: by pvb32 with SMTP id 32so719787pvb.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 20:55:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B84A049.1040904@openwrt.org>
References: <4B84A049.1040904@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 23 Feb 2010 20:48:47 -0800
Message-ID: <43e72e891002232048h14e26093lf2e98b508504686f@mail.gmail.com>
Subject: Re: [PATCH] ath9k: disable RIFS search for AR91xx based chips
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2010 at 7:43 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> While ath9k does not support RIFS yet,

Not 100% sure but I actually think we do have it enabled for
single-chip solutions and I think it should work.

> the ability to receive RIFS
> frames is currently enabled for most chipsets in the initvals.
> This is causing baseband related issues on AR9160 and AR9130 based
> chipsets, which can lock up under certain conditions.
>
> This patch fixes these issues by overriding the initvals, effectively
> disabling RIFS for all affected chipsets.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@kernel.org

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
