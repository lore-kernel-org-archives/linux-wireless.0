Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jazz.viagenie.ca ([206.123.31.2]:38683 "EHLO jazz.viagenie.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbZKYPnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 10:43:37 -0500
Message-ID: <4B0D50AE.9040008@viagenie.ca>
Date: Wed, 25 Nov 2009 10:43:42 -0500
From: Simon Perreault <simon.perreault@viagenie.ca>
MIME-Version: 1.0
To: pat-lkml@erley.org
CC: Rui Paulo <rpaulo@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Hardware for 802.11s
References: <4B0C5E6F.5040302@viagenie.ca> <4B0C6493.7010805@erley.org> <4B0D360A.3080801@viagenie.ca> <D0FDC725-10F7-473E-995F-EC842DB8AC18@gmail.com> <4B0D4E98.5090600@viagenie.ca> <66c7012a2fea8a9dd6fbdf30d0a44410@127.0.0.1>
In-Reply-To: <66c7012a2fea8a9dd6fbdf30d0a44410@127.0.0.1>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pat-lkml@erley.org wrote, on 2009-11-25 10:36:
>> The output of that looks very much like that of "iw dev mesh0 scan" with
>> different formatting.
>>
>> It doesn't help. "iw dev mesh0 station dump" is still empty.
> 
> Did you do that on both ends?

Yes.

> What is the full procedure you're using to
> set up the mesh interfaces on the nodes?  

<boot 1st WRT54GL>
<boot 2nd WRT54GL>

On 1st:
# iw phy0 interface add mesh0 type mp mesh_id mesh
# ifconfig mesh0 up
# ifconfig mesh0 10.0.0.1

On 2nd:
# iw phy0 interface add mesh0 type mp mesh_id mesh
# ifconfig mesh0 up
# ifconfig mesh0 10.0.0.2

The next step is sniffing the 802.11 packets, as Andrey Yurovsky suggested. I'll
keep you posted.

Thanks,
Simon
-- 
DNS64 open-source   --> http://ecdysis.viagenie.ca
STUN/TURN server    --> http://numb.viagenie.ca
vCard 4.0           --> http://www.vcarddav.org
