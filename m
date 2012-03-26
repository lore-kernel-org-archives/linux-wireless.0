Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53625 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2CZIva (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 04:51:30 -0400
Message-ID: <1332751883.3511.5.camel@jlt3.sipsolutions.net> (sfid-20120326_105133_997759_B297BFF8)
Subject: Re: Dell E6400 + Windows XP can not work on intel N-6205 AP mode
 for compat-wireless-2012-03-18.tar.bz2 package
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhong Hongbo <hongbo.zhong@windriver.com>
Cc: wey-yi.w.guy@intel.com, linux-wireless@vger.kernel.org,
	"Cao, Qingtao (Harry)" <Qingtao.Cao@windriver.com>,
	"Gao, Guijin" <Guijin.Gao@windriver.com>,
	"'Cabuk, Yusuf'" <Yusuf.Cabuk@windriver.com>,
	"'Foglia, Michael'" <Michael.Foglia@windriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Date: Mon, 26 Mar 2012 10:51:23 +0200
In-Reply-To: <4F6B1D8B.8060306@windriver.com>
References: <4F687667.1030605@windriver.com>
	  <1332247526.3329.17.camel@jlt3.sipsolutions.net>
	  <4F687D82.2010201@windriver.com>  <4F687F4E.4030203@windriver.com>
	 <1332248855.3329.18.camel@jlt3.sipsolutions.net>
	 <4F6B1D8B.8060306@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for the delay.

> Today, I test Intel Centrino N-6205 Taylor Peak on Linux 2.6.39, It work perfect on Windows XP. 
> 'PS debugging in ma80211'?, Do you mean that I open the 'CONFIG_MAC80211_DEBUGFS=y' and See the log?
> The detail step as following:

No, I meant CONFIG_MAC80211_VERBOSE_PS_DEBUG, but given that the iPhone
works, I can't convince myself that powersave could be the issue.

Maybe you could enable CONFIG_MAC80211_HT_DEBUG instead and see if it's
related to aggregation?

johannes

