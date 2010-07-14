Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56134 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab0GNVlY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 17:41:24 -0400
Received: by pwi5 with SMTP id 5so28428pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jul 2010 14:41:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279140598-6509-1-git-send-email-hauke@hauke-m.de>
References: <1279140598-6509-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 14 Jul 2010 14:41:00 -0700
Message-ID: <AANLkTil55aehvC7LfXjWyklj56c3UPChHM1PWBh1sFjJ@mail.gmail.com>
Subject: Re: [PATCH] compat-wireless: backport threaded-irq for rt2x00
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	philipp_subx@redfish-solutions.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 14, 2010 at 1:49 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This backport was done like for the b43 driver. This was just build tested.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks!!! Applied

  Luis
