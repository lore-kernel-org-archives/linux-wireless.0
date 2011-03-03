Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lotus.nuim.ie ([149.157.1.189]:55400 "EHLO lotus.nuim.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757224Ab1CCTp0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 14:45:26 -0500
Message-id: <4D6FEFD4.9010608@nuim.ie>
Date: Thu, 03 Mar 2011 13:45:24 -0600
From: Tianji Li <Tianji.Li@nuim.ie>
MIME-version: 1.0
To: rick.jones2@hp.com
Cc: =?ISO-8859-1?Q?Dave_T=E4ht?= <d@taht.net>, sedat.dilek@gmail.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	bloat-devel@lists.bufferbloat.net, linux-kernel@vger.kernel.org
Subject: Re: ANNOUNCE: debloat-testing kernel git tree
References: <20110225222210.GA3618@tuxdriver.com>
 <AANLkTingkcc-dvs_8Nr0vYXdXvuDHEn6sz14tnHzLp8W@mail.gmail.com>
 <87fwr9jxya.fsf@cruithne.co.teklibre.org>
 <AANLkTinpG-xAC-VV-j7EBJB522+BqCyyFd_6N3KEr2Cf@mail.gmail.com>
 <8739n9ii7z.fsf@cruithne.co.teklibre.org>
 <AANLkTi=Cp7N4xqPyU6KWF6DOzFytxaA2BeoXhnhsZ6dp@mail.gmail.com>
 <87tyfph2az.fsf@cruithne.co.teklibre.org> <1299176168.2157.14.camel@tardy>
In-reply-to: <1299176168.2157.14.camel@tardy>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/03/2011 12:16 PM, Rick Jones wrote:
>> For wireless routers and cable home gateways especially, this research
>> shows that the total un-managed buffers in your system should be less
>> than 32.
>
> Would it be a good thing to start describing these queues not so much in
> terms of packets but in terms of delay (or bandwidth X delay)?
>

The unit of bandwidth is something like Mbps, that of delay can be 
second, so bandwidth X delay --> Mb, which is the unit of packet size. 
So both packets and delay should have the same effect for sizing buffers.

Tianji



> Constants tend to live longer than they should, no matter how noble in
> birth.
>
> rick jones
>
> _______________________________________________
> Bloat-devel mailing list
> Bloat-devel@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/bloat-devel
>
