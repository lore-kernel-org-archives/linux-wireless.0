Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab0I3WaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 18:30:25 -0400
Subject: Re: [PATCH 3/3] mac80211: fix for WDS interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Bill Jordan <bjordan@rajant.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <AANLkTimN4=OcBpdVbCiO6+_n6daBD3ss+jcbmRA0MzN2@mail.gmail.com>
References: <AANLkTimN4=OcBpdVbCiO6+_n6daBD3ss+jcbmRA0MzN2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 00:31:00 +0200
Message-ID: <1285885860.5137.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 18:21 -0400, Bill Jordan wrote:
> Initialize the rate table for WDS interfaces, and
> add cases to allow WDS packets to pass the xmit and receive
> tests.

I'm surprised you're actually trying to use WDS, but the patches look OK
to me (except the ath9k one which I'm not qualified to review)

johannes

