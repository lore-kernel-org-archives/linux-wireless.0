Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:58025 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbXCLVOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 17:14:20 -0400
Message-ID: <45F5C2AA.8030002@lwfinger.net>
Date: Mon, 12 Mar 2007 16:14:18 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [RFT] [PATCH] bcm43xx: ACI fixes
References: <20070312010420.353a59c0@localhost>	<20070312070558.07488359@localhost> <45F5B805.8040401@lwfinger.net> <200703122153.34684.mb@bu3sch.de>
In-Reply-To: <200703122153.34684.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Monday 12 March 2007 21:28, Larry Finger wrote:
>> Stefano Brivio wrote:
>>> On Mon, 12 Mar 2007 00:51:19 -0500
>>>
>>> Well, wait. I'd want to see some performance improvements before the patch
>>> is applied. That's why I didn't send it to John and put RFT in the
>>> subject. Are there any?
>> No, I don't see any significant difference in RX or TX throughput with this patch. So far, I have
>> only tested on the 4311. Results for the 4306 and 4318 will come later.
> 
> Not that interference mitigation can not improve the signal,
> if there is no interference disturbing it. ;) It _is_ already
> best possible signal, then.

Of course. My environment is rather quiet. At least, the patch does no harm.

Larry


