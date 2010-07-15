Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45833 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518Ab0GONaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jul 2010 09:30:11 -0400
Date: Thu, 15 Jul 2010 09:28:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: yogeshp <yogeshp@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: indicate BA window size with
 IEEE80211_AMPDU_TX_OPERATIONAL drv_ampud_action
Message-ID: <20100715132804.GA2370@tuxdriver.com>
References: <4C3F0AA3.4050706@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C3F0AA3.4050706@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 15, 2010 at 06:48:27PM +0530, yogeshp wrote:
> BA window size for a successful BA setup is not made available to the driver by
> mac80211. The patch below gets the BA window size from addba response and
> indicates it to driver through IEEE80211_AMPDU_TX_OPERATIONAL drv_ampdu_action.
> 
> Signed-off-by: yogeshp@marvell.com
> Signed-off-by: nishants@marvell.com

This patch seems to have a lot of whitespace damage.  Please
follow the normal practices, etc.  Also, the Signed-off-by: line
typically includes the full name (e.g.  "Signed-off-by: Full Name
<namef@marvell.com>").

I didn't look too closely at the code itself, so I'll leave it to
others to comment on that...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
