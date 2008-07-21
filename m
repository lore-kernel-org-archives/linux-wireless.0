Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:37504 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510AbYGUWkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 18:40:14 -0400
Message-ID: <4885104A.2070201@lwfinger.net> (sfid-20080722_004018_678066_1822BDD3)
Date: Mon, 21 Jul 2008 17:40:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: David Miller <davem@davemloft.net>, mingo@elte.hu,
	ischram@telenet.be, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
References: <4884F3D7.4070604@lwfinger.net>	<20080721.134608.75595942.davem@davemloft.net>	<4884F6E9.6090809@trash.net> <20080721.140120.135667045.davem@davemloft.net> <4884FA3F.70109@trash.net> <48850121.9090106@trash.net> <488504D9.5090100@lwfinger.net> <488507FB.9050101@trash.net>
In-Reply-To: <488507FB.9050101@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patrick McHardy wrote:
> Larry Finger wrote:
>> Patrick McHardy wrote:
>>>
>>> This is what I was missing, we're setting a lockdep class
>>> by default depending on dev->type. This patch combined
>>> with yours should fix all addr_list_lock warnings.
>>
>> No cigar yet. I tried davem's patch first, then yours on top of his. I 
>> still get both the recursive locking and the kernel warning.
> 
> Does this one earn me my cigar? :)

Sorry :(

I used the davem patch, the second version of your first one, and your second 
one. Both problems persist.

Still plugging away on bisection.

Larry
