Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:36847 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbcDHBfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 21:35:24 -0400
Received: by mail-oi0-f41.google.com with SMTP id y204so120609155oie.3
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2016 18:35:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgUiREy2WsSD6iRZ+annBYv+dGgMWvASb=Y5+eT4gJYE_A@mail.gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com> <871t6h4o6q.fsf@purkki.adurom.net>
 <87pou11ikg.fsf@purkki.adurom.net> <CAGRGNgUiREy2WsSD6iRZ+annBYv+dGgMWvASb=Y5+eT4gJYE_A@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 8 Apr 2016 11:35:04 +1000
Message-ID: <CAGRGNgXLpzkU_NpKavvPSr2ePPXqK18FkPZ6Vx22e9Q4fdczrw@mail.gmail.com> (sfid-20160408_033533_708630_89296817)
Subject: Re: [PATCH 00/19] Pending Cleanup patches for 4.7
To: Kalle Valo <kvalo@codeaurora.org>
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
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Sara Sharon <sarasharon1@gmail.com>,
	Shahar Patury <shaharp@ti.com>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Fri, Apr 8, 2016 at 10:56 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi Kalle,
>
> On Fri, Apr 8, 2016 at 2:37 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>
>>> Julian Calaby <julian.calaby@gmail.com> writes:
>>>
>>>> This is a set of all patches in patchwork which were pending when the 4.6
>>>> merge window opened that meet the following criteria:
>>>>
>>>> 1. They're sane
>>>> 2. They're either obviously correct, I can review them, or they've been
>>>>    reviewed or ACK'd by someone else.
>>>> 3. They don't require any code changes to make them applyable.
>>>>
>>>> That said, if anyone doesn't like any of these patches for any reason,
>>>> just give me a reason and I'll drop it.
>>>>
>>>> I've split the pending patches into 4 sets as detailed below. All patches
>>>> have been rebased to apply in order on wireless-drivers-next at
>>>> wireless-drivers-next-for-davem-2016-03-14.
>>>
>>> Thank you for working on this, this is very helpful.
>>>
>>> I have deferred patch 14 and dropped patch 19[1], the rest I'm planning
>>> to apply soon. I also tried to remove the original patches from deferred
>>> queue by moving them to state "superseded", but I might missed
>>> something.
>
> I'll check that later and give you a list of patchwork URLs for
> anything you missed.

Ok, from the bundles I initially produced, you missed the following:
https://patchwork.kernel.org/patch/7939701/
https://patchwork.kernel.org/patch/8003841/
https://patchwork.kernel.org/patch/8049041/
https://patchwork.kernel.org/patch/8049011/
https://patchwork.kernel.org/patch/7940021/
https://patchwork.kernel.org/patch/8040161/
https://patchwork.kernel.org/patch/8040181/
https://patchwork.kernel.org/patch/8197881/

And this one has the status "changes requested", however I resubmitted
it as patch #15 without the stupid bits and you applied it:
https://patchwork.kernel.org/patch/8040201/

Beyond that, here's some earlier versions of the patches I picked up:
https://patchwork.kernel.org/patch/8197051/
https://patchwork.kernel.org/patch/7993931/
https://patchwork.kernel.org/patch/8040201/

This one should be dropped as it's too awful for me to endorse:
https://patchwork.kernel.org/patch/7940001/

And this one is obsolete as it's already been applied in some form:
https://patchwork.kernel.org/patch/8197071/

(If it'd make it easier for you, I can throw these all in a bundle.)

I'll poke people for reviews for patch 14 and there's also a patch I
missed in my first run-through that applies without changes, so I'll
give it a reviewed-by so it's back on your radar.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
