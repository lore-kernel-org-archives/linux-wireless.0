Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2FIIqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:46:12 -0400
Message-ID: <1339231570.4539.31.camel@jlt3.sipsolutions.net> (sfid-20120609_104616_477339_4522FE6E)
Subject: Re: [PATCH v2 3/4] mac80211: implement the proactive PREP generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Sat, 09 Jun 2012 10:46:10 +0200
In-Reply-To: <1339043963-2043-4-git-send-email-yeohchunyeow@gmail.com> (sfid-20120607_063955_450825_23A6CF28)
References: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
	 <1339043963-2043-4-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120607_063955_450825_23A6CF28)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 12:39 +0800, Chun-Yeow Yeoh wrote:

> v2: adhere to Linux kernel coding style (Johannes)

> +			if (!is_broadcast_ether_addr(target_addr)) {
> +				mesh_path_sel_frame_tx(MPATH_PREP, 0, orig_addr,
> +				    cpu_to_le32(orig_sn), 0, target_addr,

four spaces to indent? I don't think that's right right style :-)

This function really looks rife for refactoring, it's got way too many
indentation levels now.

johannes


