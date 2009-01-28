Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.225]:30164 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZA1Fav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 00:30:51 -0500
Received: by rv-out-0506.google.com with SMTP id k40so6785712rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 21:30:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090127151326.GH19242@tesla>
References: <d9360e520901270334p332b09e9sefbf1f861ecbe907@mail.gmail.com>
	 <20090127151326.GH19242@tesla>
Date: Wed, 28 Jan 2009 11:00:51 +0530
Message-ID: <d9360e520901272130t5c4112e3ya86ef92b735bb679@mail.gmail.com> (sfid-20090128_063113_779720_87052452)
Subject: Re: 802.11k support in open source mac
From: Bharat Bhushan <bharat.b.bhushan@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes you are right signal strength stats constitute major part of
802.11k but there are other feature like neighbour element report and
some other features are there which if implemented may help us in
taking roaming related decisions in open source mac. What do you say
?
bharat

On Tue, Jan 27, 2009 at 8:43 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Tue, Jan 27, 2009 at 03:34:57AM -0800, Bharat Bhushan wrote:
>> hi
>>
>>           Do open source mac support 802.11 K in main line kernel
>> source tree ? further does any one working on it ?
>>
>> Thanks in anticipation
>
> IIRC last I looked into this it seemd 802.11k is more of a device
> requirement on affinity for reporting signal amongst other things.
> At least for signal we already try to report stuff in dBm when we can,
> the resolution guarantee would be up to the device. It should be
> relatively easily to do the conversion to the 11k range but not
> sure which devices are capable of ensuring the affinity at the moment.
>
> I'm sure there is more to 11k than just signal measurement, what else
> was on it that you are interested? Too lazy to check right now.
>
>  Luis
>
