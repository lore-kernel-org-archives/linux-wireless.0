Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2GXOHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 10:07:18 -0400
Message-ID: <1343138835.4415.27.camel@jlt3.sipsolutions.net> (sfid-20120724_160806_351970_AEC563D8)
Subject: Re: [PATCH v4] mac80211: add extra checking for RC init upon
 receiving mesh beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Tue, 24 Jul 2012 16:07:15 +0200
In-Reply-To: <1343101955-16710-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20120724_055439_528013_64A531ED)
References: <1343101955-16710-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120724_055439_528013_64A531ED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-24 at 11:52 +0800, Chun-Yeow Yeoh wrote:
> Rate control statistic is flushed whenever the mesh beacon
> is received. This may not optimizes the performance of rate
> control algorithm. This patch ensures that we return early
> from mesh_peer_init if the plink_state is ESTAB. Thus, avoid
> calling the rate_control_rate_init again for established mesh
> STA.

Applied.

johannes

