Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab2K1OBR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 09:01:17 -0500
Message-ID: <1354111295.9345.25.camel@jlt4.sipsolutions.net> (sfid-20121128_150120_762602_BFCB64AD)
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from outside
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 28 Nov 2012 15:01:35 +0100
In-Reply-To: <1354042232-32428-2-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1354042232-32428-2-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-27 at 19:50 +0100, Simon Wunderlich wrote:
> It can be useful to set own WMM parameters from outside, otherwise there
> is no way to change this in Ad-Hoc networks.

Having proper WMM support for IBSS doesn't seem this simple.

What about IBSS merging? What about adding WMM IEs? etc.

johannes

