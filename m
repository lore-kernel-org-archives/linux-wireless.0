Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab2FTIvy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:51:54 -0400
Message-ID: <1340182308.4655.45.camel@jlt3.sipsolutions.net> (sfid-20120620_105205_096713_0158B9D9)
Subject: Re: [PATCH] mac80211: cleanup offchannel_ps_enable argument
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 20 Jun 2012 10:51:48 +0200
In-Reply-To: <1340026432-18947-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340026432-18947-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-18 at 19:03 +0530, Rajkumar Manoharan wrote:
> The 'tell_ap' argument is always true. So that remove it
> and simplify the function.

Applied, thanks.

johannes

