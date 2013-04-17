Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58078 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966683Ab3DQOcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 10:32:12 -0400
Message-ID: <516EB269.3010209@openwrt.org> (sfid-20130417_163220_370340_E6531ADE)
Date: Wed, 17 Apr 2013 16:32:09 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: cosmetics for minstrel_debugfs
References: <1366200506-23584-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1366200506-23584-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-17 2:08 PM, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> This changes the minstrel stats ouput from:
> 
> rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
>  BCD   6         0.0        0.0        0.0          0(  0)          0           0
> 
> to:
> 
> rate      throughput  ewma prob  this prob  this succ/attempt   success    attempts
>  BCD   6         0.0        0.0        0.0             0(  0)         0           0
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>


