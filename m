Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2KMHz5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 02:55:57 -0500
Message-ID: <1352793390.9466.0.camel@jlt4.sipsolutions.net> (sfid-20121113_085602_252934_40CE8634)
Subject: Re: [PATCH] mac80211: support RX_FLAG_MACTIME_END
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 13 Nov 2012 08:56:30 +0100
In-Reply-To: <CAJ-Vmon-ggLa7F=FiLohzRQB+0JRsr5xFeenxuw4jLRaqkMe1A@mail.gmail.com> (sfid-20121113_014842_509043_A38CFD57)
References: <1352745513-1265-1-git-send-email-thomas@cozybit.com>
	 <CAPjQAd-fniHzup-44V+KoOQT63bV8=VxAsGprH3qo6mV5y_aEw@mail.gmail.com>
	 <CAG6hwVN4ty1GzKSzWt-m6yCZ_qHfz5vHtFo_+VW4CL8sfU6r2g@mail.gmail.com>
	 <CAJ-Vmon-ggLa7F=FiLohzRQB+0JRsr5xFeenxuw4jLRaqkMe1A@mail.gmail.com>
	 (sfid-20121113_014842_509043_A38CFD57)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-12 at 16:48 -0800, Adrian Chadd wrote:
> So for the sake of being complete(ish), the Atheros hardware looks
> like it behaves slightly different for single frames versus
> aggregates.
> 
> So I guess it depends upon what kind of accuracy you're looking for?
> Would it be worth implementing it as a per-frame flag, so the driver
> has a chance of setting the flag for aggregates versus non-aggregates?

It already is a per frame flag :)

johannes

