Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-6.exch022.serverdata.net ([206.225.164.189]:51389
	"EHLO HUB022-nj-6.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984Ab2IEEyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 00:54:15 -0400
Message-ID: <5046DAF1.103@posedge.com> (sfid-20120905_065419_865641_557DBB36)
Date: Wed, 5 Sep 2012 10:24:09 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [RFC] cfg80211: VHT regulatory
References: <50457491.9020604@posedge.com> <1346747134.3737.10.camel@jlt4.sipsolutions.net> <5046D8E9.3050505@posedge.com> <CAGRGNgXkjKKoykWYAev=JpS+owTopCj0j9tLbvwDC+NDM0vzVw@mail.gmail.com>
In-Reply-To: <CAGRGNgXkjKKoykWYAev=JpS+owTopCj0j9tLbvwDC+NDM0vzVw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 10:19 AM, Julian Calaby wrote:
> Hi Mahesh,
>
>>>
>>>
>>> Hmm? Shouldn't you add 10 MHz to the lower end, if anything?
>>>
>>
>> Nope. For example 80 MHz BW, take channel 36, 40, 44 and 48. Center freq
>> value is chan 42. so left end will be chan 34 and right end will be chan 50.
>> so I am subtracting 10MHz on both ends to get chan 36 and 48
>
> Surely if you subtract 10MHz from chan 34, you'd end up with chan 32, right?

Very bad. I am wrong. It should be + 10 MHz. Thanks for quick response 
Julian.

>
> Thanks,
>
