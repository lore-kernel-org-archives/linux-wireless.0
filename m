Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41910 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753497Ab0KIWVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 17:21:22 -0500
Date: Wed, 10 Nov 2010 00:20:58 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Blaise Gassend <blaise@willowgarage.com>, linville@redhat.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: Incorporate txpower into rssi
Message-ID: <20101109222058.GA12611@jm.kir.nu>
References: <AANLkTi=t-rEsFKMv-V7Q3cyY6A_+LiBBYW2WbwXzg50b@mail.gmail.com>
 <20101109212422.GE2374@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101109212422.GE2374@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 09, 2010 at 04:24:22PM -0500, John W. Linville wrote:
> On Thu, Oct 28, 2010 at 02:01:24AM -0700, Blaise Gassend wrote:
> > Up to now mac80211_hwsim has been reporting an rssi of -50. This patch
> > improves the model slightly by returning txpower-50. This makes it
> > easy to stimulate tests that need to see a varying rssi.

> Any comments on this patch from the mac80211_hwsim users?

I'm not really using the RSSI value in my tests with hwsim at the moment
and would eventually prefer to see more complete options for simulating
changing RSSI. Anyway, the proposed change does not seem to any harm and
it can potentially help in getting somewhat different information for
simulations, so I'm fine with it.

-- 
Jouni Malinen                                            PGP id EFC895FA
