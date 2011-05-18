Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab1ERWov (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 18:44:51 -0400
Subject: Re: [Patch net-next-2.6] rfkill: remove CONFIG_RFKILL_INPUT
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <BANLkTin9EbYhOHiU-EwGDTsXegks_hAT_A@mail.gmail.com> (sfid-20110516_124438_617614_6D997BDC)
References: <BANLkTin9EbYhOHiU-EwGDTsXegks_hAT_A@mail.gmail.com>
	 (sfid-20110516_124438_617614_6D997BDC)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 15:47:28 -0700
Message-ID: <1305758848.8827.2.camel@jlt3.sipsolutions.net> (sfid-20110519_004502_747776_F7597C86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-05-16 at 18:44 +0800, Américo Wang wrote:
> This is scheduled to be removed in 2.6.33, now we are at 2.6.39-rc2.
> So I think it is safe to remove it completely.

We still don't have urfkill widely deployed, so NAK. 2.6.33 was wishful
thinking.

johannes

