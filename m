Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:59437 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZKOVif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2009 16:38:35 -0500
Received: by iwn8 with SMTP id 8so3803833iwn.33
        for <linux-wireless@vger.kernel.org>; Sun, 15 Nov 2009 13:38:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B007235.3050108@openwrt.org>
References: <4B007235.3050108@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 15 Nov 2009 13:38:21 -0800
Message-ID: <43e72e890911151338j3968b0c3g67ee2d0df679db84@mail.gmail.com>
Subject: Re: [PATCH] ath9k: fix massive rx packet loss issue
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 15, 2009 at 1:27 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> This patch fixes a regression introduced in
>
>  commit 701396910a42dc69cf0284f4727e48f5e0f83151
>  [PATCH 18/29] ath9k: avoid the copy skb->cb on every RX'd skb
>
> With that change, the rx status in skb->cb was left uninitialized
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks!

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
