Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40815 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab0KJXkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 18:40:45 -0500
Received: by iwn10 with SMTP id 10so1400032iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 15:40:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDB2967.7030805@openwrt.org>
References: <4CDB2967.7030805@openwrt.org>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 10 Nov 2010 15:40:24 -0800
Message-ID: <AANLkTinH6sLO3JMcHGGC85F7ij_RArHfBs5x2Ha+YKmm@mail.gmail.com>
Subject: Re: [PATCH 1/2] compat: add a wrapper for rfkill.h
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 10, 2010 at 3:23 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> With this we can get rid of some of the rfkill related patching mess.

Applied and pushed, thanks!

  Luis
