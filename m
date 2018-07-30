Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:39048 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbeG3Vl3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 17:41:29 -0400
Received: by mail-oi0-f44.google.com with SMTP id d189-v6so23589613oib.6
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2018 13:04:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b3a42b0c-4e8a-b1fe-56eb-74eb7e71deaf@candelatech.com>
References: <8ecda6f3-68ab-5752-c8de-4086d21ba309@candelatech.com>
 <EB834EF3-21B2-4E6F-BEA8-1411407310F0@fami-braun.de> <0896f150-13f8-daae-c956-f60a2f7feeaf@neratec.com>
 <b3a42b0c-4e8a-b1fe-56eb-74eb7e71deaf@candelatech.com>
From: Tom Psyborg <pozega.tomislav@gmail.com>
Date: Mon, 30 Jul 2018 22:04:52 +0200
Message-ID: <CAKR_QVKz5dZeL6dfstmXA7eghKc=1PNPvKQH7Qvha9H0OehEJQ@mail.gmail.com> (sfid-20180730_220456_119012_2F4C0BF1)
Subject: Re: ath9k and 16 VAP interfaces?
To: Ben Greear <greearb@candelatech.com>
Cc: Matthias May <matthias.may@neratec.com>, michael-dev@fami-braun.de,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: multipart/alternative; boundary="0000000000007bbb8705723cf9ba"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0000000000007bbb8705723cf9ba
Content-Type: text/plain; charset="UTF-8"

this is how i enabled it on htc target:
https://github.com/torvalds/linux/pull/574

On 30 July 2018 at 16:34, Ben Greear <greearb@candelatech.com> wrote:

>
>
> On 07/30/2018 04:13 AM, Matthias May wrote:
>
>> On 30/07/18 11:40, michael-dev@fami-braun.de wrote:
>>
>>> Do you mean AP interfaces as required for multiple BSS/SSIDs?
>>>
>>> I'm running a patched ath9k to have hostapd run >8 BSS on a single radio.
>>> It works fine since years.
>>>
>>
> Yes, I'd love to see any patches you can share on this as well.
>
> Thanks,
> Ben
>
>
>
>>> Regards,
>>> M. Braun
>>>
>>>
>>> Am 27. Juli 2018 15:35:28 MESZ schrieb Ben Greear <
>>> greearb@candelatech.com>:
>>>
>>>> Hello,
>>>>
>>>> Has anyone tried making ath9k able to support 16 vAP interfaces on a
>>>> single
>>>> radio?  I seem to recall that there were limitations regarding beacon
>>>> timers and such, and that is why the current limit is 8?
>>>>
>>>> Thanks,
>>>> Ben
>>>>
>>>> --
>>>> Ben Greear <greearb@candelatech.com>
>>>> Candela Technologies Inc  http://www.candelatech.com
>>>>
>>>
>>>
>> Are these patches available somewhere?
>> I'm interested to play with them :)
>>
>> BR
>> Matthias
>>
>>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>

--0000000000007bbb8705723cf9ba
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">this is how i enabled it on htc target: <a href=3D"https:/=
/github.com/torvalds/linux/pull/574">https://github.com/torvalds/linux/pull=
/574</a><span class=3D"sewuaq5cj8zgk32"></span><span class=3D"sewiybm83cm6k=
9e"></span><br></div><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On 30 July 2018 at 16:34, Ben Greear <span dir=3D"ltr">&lt;<a href=3D"m=
ailto:greearb@candelatech.com" target=3D"_blank">greearb@candelatech.com</a=
>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 =
0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><span class=3D""><br>
<br>
On 07/30/2018 04:13 AM, Matthias May wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On 30/07/18 11:40, <a href=3D"mailto:michael-dev@fami-braun.de" target=3D"_=
blank">michael-dev@fami-braun.de</a> wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Do you mean AP interfaces as required for multiple BSS/SSIDs?<br>
<br>
I&#39;m running a patched ath9k to have hostapd run &gt;8 BSS on a single r=
adio.<br>
It works fine since years.<br>
</blockquote></blockquote>
<br></span>
Yes, I&#39;d love to see any patches you can share on this as well.<br>
<br>
Thanks,<br>
Ben<div class=3D"HOEnZb"><div class=3D"h5"><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Regards,<br>
M. Braun<br>
<br>
<br>
Am 27. Juli 2018 15:35:28 MESZ schrieb Ben Greear &lt;<a href=3D"mailto:gre=
earb@candelatech.com" target=3D"_blank">greearb@candelatech.com</a>&gt;:<br=
>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hello,<br>
<br>
Has anyone tried making ath9k able to support 16 vAP interfaces on a<br>
single<br>
radio?=C2=A0 I seem to recall that there were limitations regarding beacon<=
br>
timers and such, and that is why the current limit is 8?<br>
<br>
Thanks,<br>
Ben<br>
<br>
--<br>
Ben Greear &lt;<a href=3D"mailto:greearb@candelatech.com" target=3D"_blank"=
>greearb@candelatech.com</a>&gt;<br>
Candela Technologies Inc=C2=A0 <a href=3D"http://www.candelatech.com" rel=
=3D"noreferrer" target=3D"_blank">http://www.candelatech.com</a><br>
</blockquote>
<br>
</blockquote>
<br>
Are these patches available somewhere?<br>
I&#39;m interested to play with them :)<br>
<br>
BR<br>
Matthias<br>
<br>
</blockquote>
<br>
-- <br>
Ben Greear &lt;<a href=3D"mailto:greearb@candelatech.com" target=3D"_blank"=
>greearb@candelatech.com</a>&gt;<br>
Candela Technologies Inc=C2=A0 <a href=3D"http://www.candelatech.com" rel=
=3D"noreferrer" target=3D"_blank">http://www.candelatech.com</a><br>
</div></div></blockquote></div><br></div>

--0000000000007bbb8705723cf9ba--
