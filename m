Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33879 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab2K0Ka4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 05:30:56 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so5005311eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 02:30:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAd0S9DJG5Ldn92fE+rhEsnPzDJrA9wZPkGk_bggfXSn5ty8kA@mail.gmail.com>
References: <50B470CE.8070402@think.ch> <CAGRGNgVT-Yru2ti9CWgwS5H2cfW=RTeL144zsdAmSRCAsLwOsg@mail.gmail.com>
 <CAAd0S9DJG5Ldn92fE+rhEsnPzDJrA9wZPkGk_bggfXSn5ty8kA@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 27 Nov 2012 21:30:34 +1100
Message-ID: <CAGRGNgWtaL8svKOYdggE=b0Z4xB-uo2_2L253fF-L3cf6GH6nA@mail.gmail.com> (sfid-20121127_113059_597243_2F9947BE)
Subject: Re: regulatory domain settings overwritten
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Erich Titl <erich.titl@think.ch>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

On Tue, Nov 27, 2012 at 9:27 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Tue, Nov 27, 2012 at 10:55 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Erich,
>>
>> On Tue, Nov 27, 2012 at 6:50 PM, Erich Titl <erich.titl@think.ch> wrote:
>> It's not being completely overridden and it is working as designed.
>>
>> Firstly, the default country code for all Atheros chips is the USA.
>> This is most likely because that's where the company is based.
>>
>> Secondly, your choice, China, is not being overridden. As the card is
>> saying that it's configured for the USA, and you're saying that it's
>> in China, the regulatory framework is using the intersection of the US
>> and Chinese rules to govern it's output, thereby ensuring that the
>> operation of the card complies with all the information it has about
>> it's location.
>>
>
> Just to avoid further confusion. The country code CH maps to Switzerland,
> whereas CN is China.So the second part should be about Switzerland.

I should have known that, I have a Chinese card here in Australia.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
