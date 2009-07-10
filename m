Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:53656 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbZGJSNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 14:13:41 -0400
Date: Fri, 10 Jul 2009 21:13:24 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH/RFC] mac80211_hwsim: report fixed signal strength
Message-ID: <20090710181324.GA7493@jm.kir.nu>
References: <1247237819.29747.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1247237819.29747.3.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 10, 2009 at 04:56:59PM +0200, Johannes Berg wrote:
> There's no reason to think that hwsim has any
> actual signal strength, but for testing it is
> very useful to have it report _some_ value to
> the stack so I can see if the value ends up
> being reported correctly

> Anyone have any objections? I'm not sure -- but it's still useful at
> least for me testing the upper layers.

At some point, we might even get to simulating (e.g., by a user space
app) signal strength more properly, but for now, this looks fine to me.

-- 
Jouni Malinen                                            PGP id EFC895FA
