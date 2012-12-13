Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52848 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300Ab2LMOOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 09:14:45 -0500
Message-ID: <1355408105.9463.6.camel@jlt4.sipsolutions.net> (sfid-20121213_151945_209649_9E825106)
Subject: Re: [PATCH] [mac80211] use short slot time in mesh for 5GHz
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Thu, 13 Dec 2012 15:15:05 +0100
In-Reply-To: <1355396397-25298-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20121213_121510_996380_B8236719)
References: <1355396397-25298-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20121213_121510_996380_B8236719)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 18:59 +0800, Chun-Yeow Yeoh wrote:
> Use short slot time in 5GHz for mesh. The performance is
> increased from 16.4Mbps to 23.4Mbps for two directly
> connected mesh STAs operating in legacy rate using iperf
> measurement. Almost similar to the results claimed in IBSS
> mode.

Applied (with a few small modifications)

johannes

