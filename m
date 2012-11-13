Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60931 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2KMAsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2012 19:48:39 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so4666396pad.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Nov 2012 16:48:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVN4ty1GzKSzWt-m6yCZ_qHfz5vHtFo_+VW4CL8sfU6r2g@mail.gmail.com>
References: <1352745513-1265-1-git-send-email-thomas@cozybit.com>
	<CAPjQAd-fniHzup-44V+KoOQT63bV8=VxAsGprH3qo6mV5y_aEw@mail.gmail.com>
	<CAG6hwVN4ty1GzKSzWt-m6yCZ_qHfz5vHtFo_+VW4CL8sfU6r2g@mail.gmail.com>
Date: Mon, 12 Nov 2012 16:48:39 -0800
Message-ID: <CAJ-Vmon-ggLa7F=FiLohzRQB+0JRsr5xFeenxuw4jLRaqkMe1A@mail.gmail.com> (sfid-20121113_014842_998794_4B9B114E)
Subject: Re: [PATCH] mac80211: support RX_FLAG_MACTIME_END
From: Adrian Chadd <adrian@freebsd.org>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Javier Cardona <javier@cozybit.com>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So for the sake of being complete(ish), the Atheros hardware looks
like it behaves slightly different for single frames versus
aggregates.

So I guess it depends upon what kind of accuracy you're looking for?
Would it be worth implementing it as a per-frame flag, so the driver
has a chance of setting the flag for aggregates versus non-aggregates?




Adrian
