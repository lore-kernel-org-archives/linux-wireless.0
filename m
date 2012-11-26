Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2654 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756637Ab2KZUy1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 15:54:27 -0500
Message-ID: <50B3D6F2.3040701@broadcom.com> (sfid-20121126_215435_544955_58FDC41D)
Date: Mon, 26 Nov 2012 21:54:10 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmsmac tx patches for 3.7
References: <50AE8BD3.8040902@broadcom.com>
 <20121126155455.GB27232@tuxdriver.com>
In-Reply-To: <20121126155455.GB27232@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/26/2012 04:54 PM, John W. Linville wrote:
> On Thu, Nov 22, 2012 at 09:32:19PM +0100, Arend van Spriel wrote:
> 
>> When Seth posted his rework on brcmsmac transmit, we had a number of
>> patches ready in the same area albeit less rigorous. With Seth's patches
>> lined up in wireless-next for 3.8, I am wondering what to do here.
>> Should I send our patches against the wireless tree? These patches will
>> definitely result in conflicts when merging to wireless-next, which you
>> typically do. Actually, we do not want these patches in wireless-next as
>> rework from Seth makes them irrelevant.
>>
>> Any advice on this?
> 
> If they are fixes, then they should be small and obvious -- hopefully
> that makes the merging relatively easy?  You might try applying
> them to a local wireless tree and pulling that into a local copy of
> wireless-next, then resolving the conflicts locally so that you can
> give me some idea of any tricky merges?
> 
> John
> 

Hi John,

I did already (re)submit the one 3.7 patch to you fixing a slab
corruption. As the code is reworked pretty significantly (removing
packets queues) in 3.8, I have a similar patch for 3.8 that I intend to
submit soon. So merge of the 3.7 patch can be ignored for wireless-next.

Gr. AvS


