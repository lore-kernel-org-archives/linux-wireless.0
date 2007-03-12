Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:48276 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965148AbXCLFvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 01:51:21 -0400
Message-ID: <45F4EA57.5010405@lwfinger.net>
Date: Mon, 12 Mar 2007 00:51:19 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Larry Finger <larry.finger@lwfinger.net>
CC: Stefano Brivio <stefano.brivio@polimi.it>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFT] [PATCH] bcm43xx: ACI fixes
References: <20070312010420.353a59c0@localhost> <45F4C902.9050405@lwfinger.net>
In-Reply-To: <45F4C902.9050405@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Stefano Brivio wrote:
>> Please test the following patch. It syncs ACI (Adjacent Channels
>> Interference) code to specs. I can't test it right now. Will port to
>> mac80211 branch ASAP.
>>
>>
>> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
>> ----
> 
> NACK - this patch really kills performance on my 4311. I'll see if I can find the problem.

Forget the above. The performance was killed by my AP, which needed to be rebooted. I will send this
patch on to John.

Larry

