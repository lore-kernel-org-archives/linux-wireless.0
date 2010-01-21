Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43881 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0AUTxb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 14:53:31 -0500
MIME-Version: 1.0
In-Reply-To: <1264102368-8918-1-git-send-email-hauke@hauke-m.de>
References: <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com>
	<1264102368-8918-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 21 Jan 2010 11:53:11 -0800
Message-ID: <43e72e891001211153u5e2e6618rbf3158286f0bd075@mail.gmail.com>
Subject: Re: [PATCH] compat: fix build on arm
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	awozniak@irobot.com, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2010 at 11:32 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> ARM does not provided the include file asm/compat.h. Use linux/compat.h
> instead, it includes asm/compat.h if needed.
> This patch is from OpenWRT:
> https://dev.openwrt.org/browser/trunk/package/mac80211/patches/020-fix_compat_h.patch?rev=19063
>

Thanks applied.

  Luis
