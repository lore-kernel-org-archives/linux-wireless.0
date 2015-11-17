Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:35064 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbbKQW1G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 17:27:06 -0500
Received: by igl9 with SMTP id 9so89620042igl.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2015 14:27:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALupW3CrA=q5dBAqYdRwbNpAECXNahf1NaL31jpcsEf=BkbzHg@mail.gmail.com>
References: <1447738373-15804-1-git-send-email-steve.derosier@lairdtech.com>
 <CAGRGNgXezDJhLkYKVexKQOOF7OrLLXg+M8h4M7=OJSF_qLgQvA@mail.gmail.com> <CALupW3CrA=q5dBAqYdRwbNpAECXNahf1NaL31jpcsEf=BkbzHg@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 18 Nov 2015 09:26:45 +1100
Message-ID: <CAGRGNgX3D=J4djzRvWGC_1uCbW3q5EpE9HpmdM_khnJkmks4HA@mail.gmail.com> (sfid-20151117_232710_744129_3423B46A)
Subject: Re: [PATCH 0/2] ath6kl_sdio: add control of CHIP_PWD_L via GPIO
To: Steve deRosier <derosier@gmail.com>
Cc: ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Steve deRosier <steve.derosier@lairdtech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Steve,

Firstly, always reply-to-all, don't drop the CCs.

On Wed, Nov 18, 2015 at 4:14 AM, Steve deRosier <derosier@gmail.com> wrote:
> Hi Julian,
>
> On Mon, Nov 16, 2015 at 10:10 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>>
>>
>> I want to say that this should go in DeviceTree or equivalent, however
>> ath6kl doesn't have DeviceTree support, so...
>>
>
> I can't disagree.  In fact, my first try was via DT, but the driver
> doesn't really support it and I couldn't just "bolt it on". I realized
> the chunk of DT support that is there (for bdata files) would need a
> bit of rearchitecting and I didn't have the stomach for that yet.
> Hence this approach. Later I'd like to go and move it to DT, but
> that's a different chunk of work.

I'm not the maintainer of the driver, so I can't say whether or not
your patches should be applied or not, however this really is
something that should be in DT and I suspect that your patches might
not be applied because of this.

I'll discuss this more in my reply to your other email.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
