Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966593Ab3DQPKI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 11:10:08 -0400
Message-ID: <1366211401.8217.15.camel@jlt4.sipsolutions.net> (sfid-20130417_171013_083447_18863910)
Subject: Re: [PATCH] mac80211: cosmetics for minstrel_debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Date: Wed, 17 Apr 2013 17:10:01 +0200
In-Reply-To: <1366200506-23584-1-git-send-email-karl.beldan@gmail.com> (sfid-20130417_141256_384814_77EACFA7)
References: <1366200506-23584-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130417_141256_384814_77EACFA7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-04-17 at 14:08 +0200, Karl Beldan wrote:
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

Applied this and your other patch ("optimize minstrel_ewma")

johannes

