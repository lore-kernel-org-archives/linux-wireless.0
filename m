Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2K3MnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 07:43:19 -0500
Message-ID: <1354279422.10035.30.camel@jlt4.sipsolutions.net> (sfid-20121130_134322_259203_615280E8)
Subject: Re: [PATCH v3] cfg80211: fix cmp_hidden_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
Date: Fri, 30 Nov 2012 13:43:42 +0100
In-Reply-To: <1354186114-29513-1-git-send-email-johannes@sipsolutions.net> (sfid-20121129_114814_190773_CE378E2B)
References: <1354139095-22937-1-git-send-email-johannes@sipsolutions.net>
	 <1354186114-29513-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121129_114814_190773_CE378E2B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 11:48 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The cmp_bss() comparator function uses memcmp() to
> compare the SSID. This means that cmp_hidden_bss()
> needs to similarly return a number bigger than zero
> (use 1) instead of -1 when ie1 is bigger than ie2,
> which is the case if an ie2 byte is non-zero.

applied.

johannes

