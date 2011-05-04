Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab1EDM56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 08:57:58 -0400
Subject: Re: [PATCH 04/13] open80211s: Stop using zero for address 3 in
 mesh plink mgmt frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <1304467039-7730-5-git-send-email-javier@cozybit.com> (sfid-20110504_015759_531202_D7295290)
References: <1304467039-7730-1-git-send-email-javier@cozybit.com>
	 <1304467039-7730-5-git-send-email-javier@cozybit.com>
	 (sfid-20110504_015759_531202_D7295290)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 14:57:27 +0200
Message-ID: <1304513847.3563.15.camel@jlt3.sipsolutions.net> (sfid-20110504_145801_611545_90C2FED2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-03 at 16:57 -0700, Javier Cardona wrote:
> Previous versions of 11s draft used the all zeroes address.  Current
> draft uses the same address as address 2.

There's also some code in net/wireless/scan.c that should be removed or
changed then I think?

johannes

