Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20772 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbYIHBfY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 21:35:24 -0400
Subject: Re: iwl4965 and 802.11a
From: Zhu Yi <yi.zhu@intel.com>
To: Jon Wesgate <jon@fsck.tv>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <48C3F74D.7020005@fsck.tv>
References: <48C3F74D.7020005@fsck.tv>
Content-Type: text/plain
Date: Mon, 08 Sep 2008 09:32:04 +0800
Message-Id: <1220837524.28282.300.camel@debian.sh.intel.com> (sfid-20080908_033539_570254_C161388B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-09-07 at 16:46 +0100, Jon Wesgate wrote:
> using your latest compat-2.6-old drivers I'm unable to see my 802.11a 
> network.
> It used to work ok but has been problematic since kernel 2.6.24.
> on 2.6.24 it would show up but I could only connect to it if I turned 
> wpa off.
> 2.6.25 was hopeless and so was 2.6.26 till I updated the Ucode now
> b/g 
> works fine other than having to try twice on encrypted connections
> and 
> the interface going down when the link was reset.
> It looks like your latest drivers have fixed that but 802.11a is still
> nowhere to be seen.

Which A band channel is your AP on? Please attach your dmesg with
"modprobe iwlagn debug=1". And make sure you are using the correct
regdomain for cfg80211.

Thanks,
-yi

