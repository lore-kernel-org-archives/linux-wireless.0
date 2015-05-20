Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36880 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbbETMOc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 08:14:32 -0400
Message-ID: <1432124068.19214.1.camel@sipsolutions.net> (sfid-20150520_141435_210439_7B209B12)
Subject: Re: Re: [PATCH] Added 2 new Control Frames ( Beamforming Report
 Poll & VHT NDP Announcement) defined in 802.11ac [EDT]
From: Johannes Berg <johannes@sipsolutions.net>
To: rahul.jain@samsung.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 20 May 2015 14:14:28 +0200
In-Reply-To: <1007223984.476041432122688318.JavaMail.weblogic@ep2mlwas05b>
References: <1007223984.476041432122688318.JavaMail.weblogic@ep2mlwas05b>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-20 at 11:51 +0000, Rahul Jain wrote:
> EP-FEDC771DF4FF48A9829CB85254E29FD3
> 
> Dear Johannes,
> 
> As per your request, I have updated the commit message.
> This patch is first step towards further changes to be done related to 802.11ac new frames.

Perhaps you should combine the two-liner with other patches then?

Standalone, this isn't really worthwhile I think.

> VHT Null Data Packet (NDP) Announcement - This frame is used by Beamformers to  
> gain control of the channel and identiy beformees. Beamformees will respond to  
> the NDP Announcement, while all other stations will simply defer channel access 
> until the sounding sequence is complete                                            
> ---                                                                                

Anyway you forgot S-o-b now.

johannes

