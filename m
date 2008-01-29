Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:51696 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751612AbYA2CnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 21:43:08 -0500
Message-ID: <479E928C.5000709@lwfinger.net> (sfid-20080129_024313_427668_8EB49D43)
Date: Mon, 28 Jan 2008 19:42:20 -0700
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: 'Stefano Brivio' <stefano.brivio@polimi.it>
CC: Lars Ericsson <Lars_Ericsson@telia.com>,
	"'John W. Linville'" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFT] [PATCH] rc80211-pid: fix rate adjusting
References: <00db01c861e4$abc2fea0$0b3ca8c0@gotws1589>
In-Reply-To: <00db01c861e4$abc2fea0$0b3ca8c0@gotws1589>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lars Ericsson wrote:
> Hi,
> 
> Sorry, it took me some time to start testing.
> I was using a rt2x00 kernel, which did not compile the patch.
> Am using a RT61 minPCI as the STA.
> 
> Have build a new wireless kernel and made some initial test.
> 
> Findings so far:
> 1) It does not select 11g speeds on 11b AP, fine.
> 2) It does not use 11g speeds on 11g AP, not so good.
> 3) It takes some time before the speed is adjusted.
>    I think that may be configurable, but have not spent any time on that.

I cannot confirm either 2) or 3). When I connected to a nearby 802.11g AP, it had adjusted the speed 
to 54 Mbs by the time I got the output of an iwconfig.

Larry

