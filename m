Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36061 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab0HQWDB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 18:03:01 -0400
Received: by gyd8 with SMTP id 8so295095gyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 15:03:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282069953-22360-1-git-send-email-hauke@hauke-m.de>
References: <1282069953-22360-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 17 Aug 2010 15:02:40 -0700
Message-ID: <AANLkTiknX7F_K+X9OCvmbL4_4Jks9uTehGSJaztcVW8Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] compat: miscellaneous fixes
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 17, 2010 at 11:32 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This was build tested in combination with the patches to compat-wireless.
>
> Hauke Mehrtens (3):
>  compat: backport init_dummy_netdev
>  compat: backport net_ns_type_operations
>  compat: fix warning in device_rename

All applied and pushed out, thanks!

  Luis
