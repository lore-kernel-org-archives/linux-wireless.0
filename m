Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59612 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122Ab1K1SKs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 13:10:48 -0500
Subject: Re: [PATCH 1/4] mac80211: fill rate filter for internal scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1322502917-28205-2-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111128_185634_810824_7B135F2B)
References: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1322502917-28205-2-git-send-email-siwu@hrz.tu-chemnitz.de>
	 (sfid-20111128_185634_810824_7B135F2B)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 19:10:43 +0100
Message-ID: <1322503843.4060.9.camel@jlt3.sipsolutions.net> (sfid-20111128_191051_151411_48AC876F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-28 at 18:55 +0100, Simon Wunderlich wrote:
> The rates bitmap for internal scan requests shoud be filled,
> otherwise there will be probe requests with zero rates supported.

You should probably send this as a separate bugfix, and maybe even Cc
stable.

johannes


