Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57022 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab0IYVzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Sep 2010 17:55:23 -0400
Received: by iwn5 with SMTP id 5so3481987iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Sep 2010 14:55:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285413737-782-1-git-send-email-hauke@hauke-m.de>
References: <1285413737-782-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 25 Sep 2010 14:55:02 -0700
Message-ID: <AANLkTikaemKPTK6StobcTEihaf8GdDWFhX-_OAjb-j2o@mail.gmail.com>
Subject: Re: [PATCH] compat: fix build error in init_dummy_netdev
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	philipp_subx@redfish-solutions.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 25, 2010 at 4:22 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> In kernel <= 2.6.28 the member napi_list in struct net_device is only
> availabe if CONFIG_NETPOLL is set. We should initialize it only if it
> is available.
>
> This should fix the problem reported by Philip.

Thanks applied and pushed out.

> This should also go into stable.

But it didn't apply to stable as stable doesn't have the napi stuff.

  Luis
