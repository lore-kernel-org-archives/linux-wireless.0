Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2ECOTJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 10:19:09 -0400
Message-ID: <1336054745.5167.0.camel@jlt3.sipsolutions.net> (sfid-20120503_161913_221658_087A47DB)
Subject: Re: [PATCH 17/18] mwifiex: parse beacon, probe response and assoc
 response IEs from start_ap
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	harvey yang <harvey.huawei.yang@gmail.com>
Date: Thu, 03 May 2012 16:19:05 +0200
In-Reply-To: <1336029760-22565-18-git-send-email-bzhao@marvell.com> (sfid-20120503_092407_448446_1D53B766)
References: <1336029760-22565-1-git-send-email-bzhao@marvell.com>
	 <1336029760-22565-18-git-send-email-bzhao@marvell.com>
	 (sfid-20120503_092407_448446_1D53B766)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-03 at 00:22 -0700, Bing Zhao wrote:
> From: Avinash Patil <patila@marvell.com>
> 
> Add logic for parsing tail IEs, beacon IEs, probe response IEs
> and assoc response IEs from cfg80211_ap_settings parameter of
> start_ap handler.
> 
> This patch also implements functionality to retrieve RSN IE from
> tail IE and send it to FW.

This doesn't seem right -- you should use AP SME mode and get much more
detail in other attributes? Look at ath6kl?

johannes

