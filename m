Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2K1MpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 07:45:10 -0500
Message-ID: <1354106730.9345.14.camel@jlt4.sipsolutions.net> (sfid-20121128_134539_912355_1F47BCDA)
Subject: Re: [patch] mac80211: silence NULL dereference warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Wed, 28 Nov 2012 13:45:30 +0100
In-Reply-To: <20121127173119.GC1059@elgon.mountain>
References: <20121127173119.GC1059@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 20:31 +0300, Dan Carpenter wrote:
> Smatch complains that we could dereference skb later in the function.
> It's probably unlikely, but we may as well return here and avoid it.

Good catch, applied.

johannes

