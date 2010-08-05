Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59143 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab0HES1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Aug 2010 14:27:42 -0400
Received: by iwn33 with SMTP id 33so372232iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Aug 2010 11:27:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280931516-29665-1-git-send-email-kkhere.geo@gmail.com>
References: <1280931516-29665-1-git-send-email-kkhere.geo@gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 5 Aug 2010 11:27:21 -0700
Message-ID: <AANLkTim7CqtS-oKZLp3UGRQi7dHdQyHLtL=9QRG0jC2M@mail.gmail.com>
Subject: Re: [PATCH] build fixes for compat-wireless due to PCMCIA changes
To: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 4, 2010 at 7:18 AM, Kshitij Kulshreshtha
<kkhere.geo@gmail.com> wrote:
> Hello,
> here are two patches for compat and compat-wireless that fix build with
> linux-next.git tag next-20100804 and kernel v2.6.34
>
> The patch for compat-wireless is only
> leftovers from Luis R. Rodriguez' commit dedb6981 in
> drivers/net/wireless/orinoco/{orinoco,spectrum}_cs.c
>
> The patch for compat backports the newly added pcmcia_{read,write}_config_byte()
> functions in <pcmcia/ds.h>
>
> Thanks and regards.

Thank you, patches applied and pushed out!

  Luis
