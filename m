Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43920 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2IEEuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 00:50:04 -0400
Received: by eaac11 with SMTP id c11so21137eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2012 21:50:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5046D8E9.3050505@posedge.com>
References: <50457491.9020604@posedge.com> <1346747134.3737.10.camel@jlt4.sipsolutions.net>
 <5046D8E9.3050505@posedge.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 5 Sep 2012 14:49:42 +1000
Message-ID: <CAGRGNgXkjKKoykWYAev=JpS+owTopCj0j9tLbvwDC+NDM0vzVw@mail.gmail.com> (sfid-20120905_065008_895494_9E17AEFC)
Subject: Re: [RFC] cfg80211: VHT regulatory
To: Mahesh Palivela <maheshp@posedge.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mahesh,

On Wed, Sep 5, 2012 at 2:45 PM, Mahesh Palivela <maheshp@posedge.com> wrote:
> On 09/04/2012 01:55 PM, Johannes Berg wrote:
>>
>> On Tue, 2012-09-04 at 08:55 +0530, Mahesh Palivela wrote:
>>> +       left_end_freq -= MHZ_TO_KHZ(10);
>>> +       right_end_freq -= MHZ_TO_KHZ(10);
>>
>>
>> Hmm? Shouldn't you add 10 MHz to the lower end, if anything?
>>
>
> Nope. For example 80 MHz BW, take channel 36, 40, 44 and 48. Center freq
> value is chan 42. so left end will be chan 34 and right end will be chan 50.
> so I am subtracting 10MHz on both ends to get chan 36 and 48

Surely if you subtract 10MHz from chan 34, you'd end up with chan 32, right?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
