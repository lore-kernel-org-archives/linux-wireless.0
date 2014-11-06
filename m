Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49817 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaKFWct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 17:32:49 -0500
Message-ID: <1415313166.17015.20.camel@sipsolutions.net> (sfid-20141106_233252_897951_F9D997A2)
Subject: Re: [PATCH] mac80211: add back support for radiotap vendor
 namespace data
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 06 Nov 2014 23:32:46 +0100
In-Reply-To: <545BF6B5.6050205@candelatech.com>
References: <1415312956-9442-1-git-send-email-johannes@sipsolutions.net>
	 <545BF6B5.6050205@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-06 at 14:31 -0800, Ben Greear wrote:
> On 11/06/2014 02:29 PM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Radiotap vendor namespace data might still be useful, but we
> > reverted it because it used too much space in the RX status.
> > Put it back, but address the space problem by using a single
> > but only and putting everything else into the skb->data.
> 
>   ^^ typo?

yeah, should say "single bit", thanks!

johannes

