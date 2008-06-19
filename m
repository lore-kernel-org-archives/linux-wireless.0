Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:37512 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289AbYFSBT0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 21:19:26 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K98o6-0005Ex-Uf
	for linux-wireless@vger.kernel.org; Thu, 19 Jun 2008 01:19:22 +0000
Received: from cpc3-cwma2-0-0-cust15.swan.cable.ntl.com ([81.96.204.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 01:19:22 +0000
Received: from andy by cpc3-cwma2-0-0-cust15.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 01:19:22 +0000
To: linux-wireless@vger.kernel.org
From: Andrew Price <andy@andrewprice.me.uk>
Subject: Re: BUG: mac80211: Some connections hanging in 2.6.26-rc6...
Date: Thu, 19 Jun 2008 02:19:12 +0100
Message-ID: <g3cc6h$q5d$1@ger.gmane.org> (sfid-20080619_031958_028400_7BC16156)
References: <g38o2j$1uh$1@ger.gmane.org>	 (sfid-20080617_181742_447297_198DA5E5) <1213773749.3803.155.camel@johannes.berg>	 <g3b7l1$t1o$1@ger.gmane.org> (sfid-20080618_165548_538551_7C9BA1D8) <1213803761.1312.29.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <1213803761.1312.29.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/06/08 16:42, Johannes Berg wrote:
> Hence, that commit is now reverted, see
> http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=3a5be7d4b079f3a9ce1e8ce4a93ba15ae6d00111

I've updated my kernel to Linus' latest since he merged Dave's revert
and I'm pleased to say the bug is now gone. Thanks for your help (and
thanks to Dave too).

--
Andy Price

