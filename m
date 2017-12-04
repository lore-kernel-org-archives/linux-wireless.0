Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:39282 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752997AbdLDFgy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 00:36:54 -0500
Received: by mail-wm0-f42.google.com with SMTP id i11so12039458wmf.4
        for <linux-wireless@vger.kernel.org>; Sun, 03 Dec 2017 21:36:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1512290364.4827.57.camel@coelho.fi>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
 <1509434718.4492.195.camel@coelho.fi> <CAB4CAwc43h5g+zLYd3hv=STELNGH+NEeQOMAXd-Gm0xj+TNuyA@mail.gmail.com>
 <1509952948.4492.360.camel@coelho.fi> <CAB4CAwc0G0j1zb+Z4z6iCJ2hzMznUsSVxyF8G3dbZn9pxzffng@mail.gmail.com>
 <CAB4CAwcwVEyFX=7KJcAT9eXQoof_M+U+tB+FRQCnoP5WgK-MrQ@mail.gmail.com>
 <1510825750.4011.179.camel@coelho.fi> <CAB4CAwfg73wRoNca2GBaMn4eN04vf+uR3xdzYO0UWG1Nmaqo=w@mail.gmail.com>
 <1510901207.4011.197.camel@coelho.fi> <CAB4CAwcit2jqHXs7x2cowHdi31OH3wKnmyW4=v-6RGO-+1gjog@mail.gmail.com>
 <CAB4CAwdZHwC0kiaGU5A1u_P8y0anw58o6KiOXAWbjwUtB=uLuQ@mail.gmail.com>
 <1511689749.4011.357.camel@coelho.fi> <CAB4CAwf6uBbMgT_=Qb5uo+2g_sNSLdRhnjJt-C9vB6OgSjphyg@mail.gmail.com>
 <CAB4CAweoq=PAqjPW_POLy5+9tHFquunoY6h5xNJ9EU=xY5zcxg@mail.gmail.com>
 <1512107590.4827.38.camel@coelho.fi> <1512290364.4827.57.camel@coelho.fi>
From: Chris Chiu <chiu@endlessm.com>
Date: Mon, 4 Dec 2017 13:36:52 +0800
Message-ID: <CAB4CAwd68miZHrVxhx2nGey-6685+19d4wXvhCux1KER+j1KNQ@mail.gmail.com> (sfid-20171204_063658_925756_28145BA6)
Subject: Re: [linuxwifi] Need support for Intel new wifi module 9462NGW
To: Luca Coelho <luca@coelho.fi>
Cc: johannes.berg@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luca,
    I applied https://patchwork.kernel.org/patch/10088929/ and
https://patchwork.kernel.org/patch/10088939/, I can access internet
thru 9461/9462NGW now. Thanks so much.

Chris

On Sun, Dec 3, 2017 at 4:39 PM, Luca Coelho <luca@coelho.fi> wrote:
> On Fri, 2017-12-01 at 07:53 +0200, Luca Coelho wrote:
>> On Fri, 2017-12-01 at 13:29 +0800, Chris Chiu wrote:
>> > Hi Luca,
>> >     I think the problem is not missing DHCP reply. I installed
>> > tcpdump
>> > on the machine with Intel 9461NGW and start monitoring on the wlan
>> > interface.
>> > The result is following
>> > https://gist.github.com/mschiu77/f4cc14ddae6adf137da15675cca59b30
>> >
>> > I also attach the ifconfig result at the end of the above url. Hope
>> > this can help a little.
>>
>> Hi Chris,
>>
>> Sorry for the delay.  We've been testing this internally, but
>> couldn't
>> reproduce it at first.  The problems seems to be with the firmware
>> that
>> we released.
>>
>> I'll provide you an update today or latest by Monday next week.
>
> Hi Chris,
>
> We found a patch that was missing from upstream and causes data
> corruption on secure associations:
>
> https://patchwork.kernel.org/patch/10088939/
>
>
> Can you try to apply this patch and see if it fixes the problem you are
> having?
>
> --
> Cheers,
> Luca.
