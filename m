Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:37783 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbaBGUtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 15:49:46 -0500
Date: Fri, 7 Feb 2014 14:50:12 -0600
From: Calvin Owens <jcalvinowens@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ieee80211: Print human-readable disassoc/deauth reason
 codes
Message-ID: <20140207205012.GA2974@gmail.com> (sfid-20140207_215031_217968_394093C8)
References: <1391651088-31785-1-git-send-email-jcalvinowens@gmail.com>
 <1391675824.12789.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1391675824.12789.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 02/06 at 09:37 +0100, Johannes Berg wrote:
> On Wed, 2014-02-05 at 19:44 -0600, Calvin Owens wrote:
> > Create a function to return a descriptive string for each reason code,
> > and print that instead of the numeric value in the kernel log. These
> > codes are easily found on popular search engines, but one is generally
> > not able to access the internet when dealing with wireless connectivity
> > issues.
> 
> I believe both iw and wpa_supplicant already have the reason code
> printout, and if you're diagnosing connectivity issues then you're
> probably using those anyway (e.g. iw event -t), so I don't really see
> much point in adding this to the kernel?
> 
> johannes

Ah, I didn't realize `iw` would interpret the reason code for you.

There were a couple of other replies expressing interest in this though.
Should I rewrite the patch per Joe Perches' suggestions and resend it?
Or should I just drop it since you can obtain the info from `iw`?

Thanks,
Calvin
