Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44607 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2LDOy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:54:28 -0500
Message-ID: <1354632891.9608.2.camel@jlt4.sipsolutions.net> (sfid-20121204_155431_889677_03D85714)
Subject: Re: [PATCH] mac80211: adapt slot time in IBSS mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Tue, 04 Dec 2012 15:54:51 +0100
In-Reply-To: <1354569690-23559-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354569690-23559-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-03 at 22:21 +0100, Simon Wunderlich wrote:
> In 5GHz/802.11a, we are allowed to use short slot times. Doing this
> may increases performance by 20% for legacy connections (54 MBit/s).
> I can confirm this in my tests (27% more throughput using iperf), and
> also have a small positive effect (5% more throughput) for HT rates,
> tested on 1 stream.

Applied.

johannes

