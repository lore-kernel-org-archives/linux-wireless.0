Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:5167 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbXDIBL2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2007 21:11:28 -0400
Subject: Re: Is it possible to test ipw2200 / mac80211 in 2.6.21-rc6-mm1?
From: Zhu Yi <yi.zhu@intel.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0704081723q5b66baa8u23d2dda6d7ac0c91@mail.gmail.com>
References: <a44ae5cd0704081723q5b66baa8u23d2dda6d7ac0c91@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 09:09:44 +0800
Message-Id: <1176080985.16123.158.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2007-04-08 at 20:23 -0400, Miles Lane wrote:
> Hello,
> 
> I notice that mac80211 is in Andrew's tree, but I don't seem to be
> able to build ipw2200 without including the current softmac stuff.
> I'd like to test the mac80211 code.  Is there a way to do this for
> ipw2200 currently?  Do I have to use one of the development git trees?

No. ipw2100/2200 currently only work with ieee80211. iwlwifi drivers for
ipw3945/4965 cards work with mac80211.
http://intellinuxwireless.org/

Thanks,
-yi
