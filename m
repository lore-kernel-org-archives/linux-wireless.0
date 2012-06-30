Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2F3UDx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 16:03:53 -0400
Message-ID: <1341086628.4485.0.camel@jlt3.sipsolutions.net> (sfid-20120630_220357_361201_471A2FB8)
Subject: Re: [PATCH v3] mac80211: correct size the argument to kzalloc in
 minstrel_ht
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.co, wfg@linux.intel.com,
	linux-wireless@vger.kernel.org, franzschrober@yahoo.de,
	julian.calaby@gmail.com, nbd@openwrt.org
Date: Sat, 30 Jun 2012 22:03:48 +0200
In-Reply-To: <1341086126-99685-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
References: <1341086126-99685-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-30 at 21:55 +0200, Thomas Huehn wrote:
> msp has type struct minstrel_ht_sta_priv not struct minstrel_ht_sta.
> 
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
> Use suggested coding style. Thx to Schrober.
> Correct an error reported in sane. Thx to Fengguang Wu.

Your other patch was already applied ....

johannes

