Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2FLLyw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 07:54:52 -0400
Message-ID: <1339502090.4531.4.camel@jlt3.sipsolutions.net> (sfid-20120612_135455_344763_EF273898)
Subject: Re: [PATCH 2/4] mwifiex: parse WPA IE and support WPA/WPA2 mixed
 mode for uAP
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Tue, 12 Jun 2012 13:54:50 +0200
In-Reply-To: <1339463659-10736-2-git-send-email-bzhao@marvell.com> (sfid-20120612_031447_380591_5EFEE2F4)
References: <1339463659-10736-1-git-send-email-bzhao@marvell.com>
	 <1339463659-10736-2-git-send-email-bzhao@marvell.com>
	 (sfid-20120612_031447_380591_5EFEE2F4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-11 at 18:14 -0700, Bing Zhao wrote:
> From: Avinash Patil <patila@marvell.com>
> 
> Add support for parsing WPA IE from beacon parameter of
> cfg80211_ap_settings and set it to FW.
> 
> WPA/WPA2 mixed mode is supported with this patch.

There's the crypto settings thing -- does that not supported mixed mode?

johannes

