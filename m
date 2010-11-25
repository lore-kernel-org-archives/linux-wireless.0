Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0KYI1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 03:27:21 -0500
Subject: Re: [PATCH] compat-wireless:Fix interface redefine when backport
 to 2.6.32
From: Johannes Berg <johannes@sipsolutions.net>
To: Youquan Song <youquan.song@linux.intel.com>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	hui.xiao@intel.com, youquan.song@intel.com
In-Reply-To: <20101125200539.GA31878@linux-youquan.bj.intel.com>
References: <20101125200539.GA31878@linux-youquan.bj.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Nov 2010 09:27:15 +0100
Message-ID: <1290673635.3770.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-25 at 15:05 -0500, Youquan Song wrote:
> Netdev_alloc_skb_ip_align already define at 2.6.32 kernel, so only < 2.6.32 
> kernel needs it, so when backport latest compat-wirelss to 2.6.32, it report
> redefine the interface.

That doesn't seem to be true:

$ git describe --contains --match=v* 61321bbd
v2.6.33-rc1~388^2~825

Maybe you're using a patched (distro) kernel?

johannes

