Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39182 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab0CLBFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 20:05:23 -0500
Subject: Re: [PATCH 2/5] compat-wireless: add orinoco to compat-wireless
From: Pavel Roskin <proski@gnu.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
In-Reply-To: <1268343167-2961-5-git-send-email-hauke@hauke-m.de>
References: <1268343167-2961-1-git-send-email-hauke@hauke-m.de>
	 <1268343167-2961-5-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain
Date: Thu, 11 Mar 2010 20:05:18 -0500
Message-Id: <1268355918.22460.3.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-11 at 22:32 +0100, Hauke Mehrtens wrote:
> orinoco now depends on cfg80211. If compat-wireless was installed it
> will install its own version of cfg80211 and orinoco will not work any
> more because it wants to use the version shipped with the kernel.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

If orinoco is in compat-wireless and hostap is not, I'm concerned that
users with hostap would end up with a less capable orinoco driver.

I'm going to make a patch that would disable support for Prism chipset
in Orinoco by default.  It should have been done long ago, but I never
had a chance, and patches proposed by others had quality issues.

-- 
Regards,
Pavel Roskin
