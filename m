Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293Ab0LPS4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 13:56:48 -0500
Subject: Re: [PATCH] mac80211: Remove unused third address from mesh
 address extension header.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1292524241-14837-1-git-send-email-javier@cozybit.com>
References: <1292524241-14837-1-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 19:56:46 +0100
Message-ID: <1292525806.3612.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 10:30 -0800, Javier Cardona wrote:
> The Mesh Control header only includes 0, 1 or 2 addresses. If there is
> one address, it should be interpreted as Address 4.  If there are 2,
> they are interpreted as Addresses 5 and 6 (Address 4 being the 4th
> address in the 802.11 header).

Is this a draft change? Not sure I understand.

johannes

