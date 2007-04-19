Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:35224 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S637771AbXDSOGr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 10:06:47 -0400
Message-ID: <46277808.9000906@lwfinger.net>
Date: Thu, 19 Apr 2007 09:09:12 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 2/3] bcm43xx-mac80211: Fix machine check on PPC for phy->rev  == 1
References: <462772da.WTFJ4M8EynD9kYbu%Larry.Finger@lwfinger.net> <20070419155805.611244ec@localhost>
In-Reply-To: <20070419155805.611244ec@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio wrote:
> On Thu, 19 Apr 2007 08:47:06 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> @@ -599,16 +599,16 @@ static void bcm43xx_phy_agcsetup(struct 
> 
> Just FYI, I'm going to whack this whole function soon, when the R.E. team
> is done with A PHY LO specifications and I release the patchset I previously
> talked about. In the meanwhile, if this really fixes machine checks, I ACK
> this.

Thanks. It really does fix the machine checks, but what is even better is that I can find them on my 
x86 hardware before the code is sent upstream. If you want, I will test your patchset for this problem.

Larry
