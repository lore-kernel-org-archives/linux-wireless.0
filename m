Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38366 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0FQFgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 01:36:10 -0400
Received: by pwi1 with SMTP id 1so4089224pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jun 2010 22:36:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1276721366-8054-1-git-send-email-hauke@hauke-m.de>
References: <1276721366-8054-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 16 Jun 2010 22:35:50 -0700
Message-ID: <AANLkTinnKQhp9FFCWGIwPmC3aBZgRFP2rqlcRCwWRLFZ@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: backport netdev->br_port
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 1:49 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> In commit f350a0a87374418635689471606454abc7beaa3a the br_port
> attribute was replaced with a private flag.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks, applied!

  Luis
