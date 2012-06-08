Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50385 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761337Ab2FHSXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 14:23:50 -0400
Received: by yhmm54 with SMTP id m54so1500483yhm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 11:23:50 -0700 (PDT)
Message-ID: <4FD24332.3010202@lwfinger.net> (sfid-20120608_202359_034724_C6E2436F)
Date: Fri, 08 Jun 2012 13:23:46 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Andre Heider <a.heider@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i]
 >= n_queues))
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com> <1339167160.4901.0.camel@jlt3.sipsolutions.net> <CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com> <1339168452.5748.0.camel@jlt3.sipsolutions.net> <1339168600.5748.2.camel@jlt3.sipsolutions.net> <CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com> <4FD21C6B.5000402@lwfinger.net> <1339170182.5748.7.camel@jlt3.sipsolutions.net> <1339170287.5748.8.camel@jlt3.sipsolutions.net> <1339170510.5748.9.camel@jlt3.sipsolutions.net> <1339170742.5748.10.camel@jlt3.sipsolutions.net> <CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com> <1339171159.5748.11.camel@jlt3.sipsolutions.net> <CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com> <4FD22727.7000500@lwfinger.net> <1339172904.5748.18.camel@jlt3.sipsolutions.net> <20120608183339.78a7fcbd@milhouse> <4FD239AA.9090708@lwfinger.net> <20120608201053.48548a11@milhouse>
In-Reply-To: <20120608201053.48548a11@milhouse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/08/2012 01:10 PM, Michael Büsch wrote:
> On Fri, 08 Jun 2012 12:43:06 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
>> On 06/08/2012 11:33 AM, Michael Büsch wrote:
>>>
>>> Larry, did you check with PIO?
>>
>> No, I only used DMA. With the latest patch, compilation is Ok, and DMA works for
>> both kinds of firmware, while PIO fails for both.
>
> Does PIO even work without that patch and with prop-firmware?

No. That seems to be a different bug.

Larry

