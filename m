Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1794 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946Ab1CXOWo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 10:22:44 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] mac80211: rename RX_FLAG_TSFT
References: <1298469968.4122.8.camel@jlt3.sipsolutions.net>
 <op.vsunv6ae3ri7v4@arend-laptop>
 <1300973845.26265.4.camel@jlt3.sipsolutions.net>
Date: Thu, 24 Mar 2011 15:22:33 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vsup7vcc3ri7v4@arend-laptop>
In-Reply-To: <1300973845.26265.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 24 Mar 2011 14:37:25 +0100, Johannes Berg  
<johannes@sipsolutions.net> wrote:

> include/net/mac80211.h:
>
>  * @mactime: value in microseconds of the 64-bit Time Synchronization  
> Function
>  *      (TSF) timer when the first data symbol (MPDU) arrived at the  
> hardware.
>
>
> Not sure what else to say ... reading the TSF when processing the frame
> in software is clearly bogus.

You are right. Have to look what the hardware is providing us. Probably we  
do get some timestamp.

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

