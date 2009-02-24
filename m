Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:35855 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750882AbZBXSm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 13:42:27 -0500
Message-ID: <49A43F8A.5000500@lwfinger.net> (sfid-20090224_194239_154920_B74432D0)
Date: Tue, 24 Feb 2009 12:42:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
CC: Lorenzo Nava <navalorenx@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: More data on open-source firmware crash
References: <49A1A331.9080205@lwfinger.net> <80C13710-6BA9-4F14-95B5-82C3043CE93B@ing.unibs.it> <49A41F1D.9060300@lwfinger.net> <03E07CC7-A971-4EDD-9363-628B61E94A92@ing.unibs.it> <49A421ED.7000801@lwfinger.net> <7528B52E-1B77-4CA9-A17F-01E24FDF81DC@ing.unibs.it>
In-Reply-To: <7528B52E-1B77-4CA9-A17F-01E24FDF81DC@ing.unibs.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Francesco Gringoli wrote:
> 
> On Feb 24, 2009, at 5:35 PM, Larry Finger wrote:
> 
>> Francesco Gringoli wrote:
>>> What about drop info from dmesg? Another try could be halve the dma
>>> queue, I believe now it is 64 slots. Could you give a try setting it
>>> to 32?
>>
>> The RX DMA queue was 64 and TX was 256. Both will be 32 in my next run.
>>
>> I don't understand the "drop info from dmesg" part.
> Sorry Larry,
> 
> sometimes when I modify something, I can read
> 
> [334415.451028] b43-phy244 debug: RX: Packet dropped
> 
> in the dmesg because the received bytes were not correctly copied
> between the "air-buffer" to the internal buffer and finally to the
> rx-fifo along with the rxheader.
> 
> Did you notice something similar?

I hadn't noticed them before, but I do see one of these messages just before
some of my out-of-order cookies. There is no associated diagnostic message, thus
it must come from the status.rate_index test. I'll see if I can get some info
from there.

Larry

