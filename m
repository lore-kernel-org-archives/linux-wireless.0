Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60685 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab2FLLyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 07:54:31 -0400
Message-ID: <1339502065.4531.3.camel@jlt3.sipsolutions.net> (sfid-20120612_135434_518110_407F4028)
Subject: Re: [PATCH 3/4] mwifiex: add 11n support for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>, Ying Luo <luoy@marvell.com>,
	Frank Huang <frankh@marvell.com>, Jouni Malinen <j@w1.fi>
Date: Tue, 12 Jun 2012 13:54:25 +0200
In-Reply-To: <1339463659-10736-3-git-send-email-bzhao@marvell.com> (sfid-20120612_031449_661395_EE5E9722)
References: <1339463659-10736-1-git-send-email-bzhao@marvell.com>
	 <1339463659-10736-3-git-send-email-bzhao@marvell.com>
	 (sfid-20120612_031449_661395_EE5E9722)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-11 at 18:14 -0700, Bing Zhao wrote:
> From: Avinash Patil <patila@marvell.com>
> 
> Parse HT IE from cfg80211 and set HT capabilities accordingly
> to FW. If HT IE is missing, 11n would be disabled in FW.

No objections, but it might be worthwhile to extend the APIs to not have
to parse this?

johannes

