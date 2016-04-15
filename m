Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34263 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbcDOMEd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2016 08:04:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Alexander Tsoy <alexander@tsoy.me>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Andrea Merello <andrea.merello@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>, ath9k-devel@lists.ath9k.org,
	b43-dev <b43-dev@lists.infradead.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Byeoungwook Kim <quddnr145@gmail.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Colin Ian King <colin.king@canonical.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Eyal Reizer <eyalreizer@gmail.com>,
	Franky Lin <frankyl@broadcom.com>,
	Geliang Tang <geliangtang@163.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Ivan Safonov <insafonov@gmail.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luca@coelho.fi>,
	Luis Felipe Dominguez Vega <lfdominguez@nauta.cu>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Miaoqing Pan <miaoqing@codeaurora.org>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Nicolas Pitre <nico@linaro.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Sara Sharon <sarasharon1@gmail.com>,
	Shahar Patury <shaharp@ti.com>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 00/19] Pending Cleanup patches for 4.7
References: <cover.1458262312.git.julian.calaby@gmail.com>
	<871t6h4o6q.fsf@purkki.adurom.net> <87pou11ikg.fsf@purkki.adurom.net>
	<CAGRGNgUiREy2WsSD6iRZ+annBYv+dGgMWvASb=Y5+eT4gJYE_A@mail.gmail.com>
	<CAGRGNgXLpzkU_NpKavvPSr2ePPXqK18FkPZ6Vx22e9Q4fdczrw@mail.gmail.com>
Date: Fri, 15 Apr 2016 15:04:19 +0300
In-Reply-To: <CAGRGNgXLpzkU_NpKavvPSr2ePPXqK18FkPZ6Vx22e9Q4fdczrw@mail.gmail.com>
	(Julian Calaby's message of "Fri, 8 Apr 2016 11:35:04 +1000")
Message-ID: <87inzjqdrw.fsf@kamboji.qca.qualcomm.com> (sfid-20160415_140438_619552_4126009B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby <julian.calaby@gmail.com> writes:

> On Fri, Apr 8, 2016 at 10:56 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> Hi Kalle,
>>
>> On Fri, Apr 8, 2016 at 2:37 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>>> Kalle Valo <kvalo@codeaurora.org> writes:
>>>
>>>> Thank you for working on this, this is very helpful.
>>>>
>>>> I have deferred patch 14 and dropped patch 19[1], the rest I'm planning
>>>> to apply soon. I also tried to remove the original patches from deferred
>>>> queue by moving them to state "superseded", but I might missed
>>>> something.
>>
>> I'll check that later and give you a list of patchwork URLs for
>> anything you missed.
>
> Ok, from the bundles I initially produced, you missed the following:
> https://patchwork.kernel.org/patch/7939701/
> https://patchwork.kernel.org/patch/8003841/
> https://patchwork.kernel.org/patch/8049041/
> https://patchwork.kernel.org/patch/8049011/
> https://patchwork.kernel.org/patch/7940021/
> https://patchwork.kernel.org/patch/8040161/
> https://patchwork.kernel.org/patch/8040181/
> https://patchwork.kernel.org/patch/8197881/

Changed these to "Superseded"

> And this one has the status "changes requested", however I resubmitted
> it as patch #15 without the stupid bits and you applied it:
> https://patchwork.kernel.org/patch/8040201/

Ok, I changed it to Superseded.

> Beyond that, here's some earlier versions of the patches I picked up:
> https://patchwork.kernel.org/patch/8197051/
> https://patchwork.kernel.org/patch/7993931/
> https://patchwork.kernel.org/patch/8040201/

Marked as Superseded.

> This one should be dropped as it's too awful for me to endorse:
> https://patchwork.kernel.org/patch/7940001/

It's now "Rejected".

> And this one is obsolete as it's already been applied in some form:
> https://patchwork.kernel.org/patch/8197071/

I put it to Superseded.

> (If it'd make it easier for you, I can throw these all in a bundle.)

No need, this was perfect.

> I'll poke people for reviews for patch 14 and there's also a patch I
> missed in my first run-through that applies without changes, so I'll
> give it a reviewed-by so it's back on your radar.

Thank you so much for all this, I appreciate it a lot.

-- 
Kalle Valo
