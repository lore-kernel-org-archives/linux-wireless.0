Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32954 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab0KVBcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 20:32:23 -0500
Received: by iwn34 with SMTP id 34so2235884iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 21 Nov 2010 17:32:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290372517-6777-1-git-send-email-hauke@hauke-m.de>
References: <1290372517-6777-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 21 Nov 2010 17:32:02 -0800
Message-ID: <AANLkTime_MPWoTkoHRt-MZuboXOzFAXpV29JVy4nt-Gn@mail.gmail.com>
Subject: Re: [PATCH 1/2] compat: backport Generic exponentially weighted
 moving average (EWMA)
To: Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 21, 2010 at 12:48 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Thanks Hauke! John, are you going to revert EWMA stuff? If so maybe I
should wait to merge this.

  Luis
