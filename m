Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34214 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753719AbbLCUYI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 15:24:08 -0500
Message-ID: <1449174245.31265.4.camel@sipsolutions.net> (sfid-20151203_212411_995514_8784F610)
Subject: Re: Can we increase IEEE80211_MAX_QUEUES
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 03 Dec 2015 21:24:05 +0100
In-Reply-To: <1449174081.31265.3.camel@sipsolutions.net> (sfid-20151203_212138_334045_9AA12B0C)
References: <5660A31E.3010507@candelatech.com>
	 (sfid-20151203_211637_306021_AF98F120) <1449174081.31265.3.camel@sipsolutions.net>
	 (sfid-20151203_212138_334045_9AA12B0C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-03 at 21:21 +0100, Johannes Berg wrote:
> 
> Does the original premise even make sense though? A single queue for
> each vdev seems a bit strange.
> 

Btw, it might make more sense to use Felix's txq scheduling thing for
this, where you get a txq for each station. You can still combine them
back any way you want in the driver.

johannes
