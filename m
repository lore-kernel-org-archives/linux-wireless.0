Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:46819 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752586AbdLEMxH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 07:53:07 -0500
Received: by mail-wr0-f171.google.com with SMTP id x49so134286wrb.13
        for <linux-wireless@vger.kernel.org>; Tue, 05 Dec 2017 04:53:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a5d827e7-6846-a903-0b1f-55132ddf2631@exactcode.com>
References: <d776bc3d-7712-8430-93e2-72e4b6bbf23c@exactcode.com>
 <CAAfyv35EDMmyW_FTJJsNbOweivd=xwDgb=omRA4swQiu4ZXUqQ@mail.gmail.com> <a5d827e7-6846-a903-0b1f-55132ddf2631@exactcode.com>
From: Belisko Marek <marek.belisko@gmail.com>
Date: Tue, 5 Dec 2017 13:53:05 +0100
Message-ID: <CAAfyv37krH2qOkc+QQVdgbhoNhYYV8_ok_qRpyVMLHL5y1SHSw@mail.gmail.com> (sfid-20171205_135311_313846_F860984A)
Subject: Re: MWIFIEX still unstable after two years on MS Surface Pro 3
To: =?UTF-8?Q?Ren=C3=A9_Rebe?= <rene@exactcode.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rene,

On Tue, Dec 5, 2017 at 1:31 PM, Ren=C3=A9 Rebe <rene@exactcode.com> wrote:
> Hi Marek,
>
> thank you for your blazingly fast reply.
np.
>
> On 12/05/2017 12:41 PM, Belisko Marek wrote:
>>
>> Hi Rene,
>>
>> On Tue, Dec 5, 2017 at 12:06 PM, Ren=C3=A9 Rebe <rene@exactcode.com> wro=
te:
>>>
>>> Hi all,
>>>
>>> I write to start a discussion about the state of the mwifiex driver.
>>> For over two years many other and me wait that the driver finally becom=
es
>>> "stable". However, even with kernel 4.14.2 it still fails after some
>>> minutes, or latest after some hours. With various stray errors in the
>>> system
>>> log:
>>>
>>> Dec  5 09:50:50 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: MWIFI=
EX
>>> VERSION: mwifiex 1.0 (15.68.7.p119)
>>> Dec  5 09:50:50 surface3 kernel: mwifiex_pcie 0000:01:00.0:
>>> driver_version =3D
>>> mwifiex 1.0 (15.68.7.p119)
>>>
>>> Dec  5 10:38:28 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: tryin=
g
>>> to
>>> associate to 'XXX' bssid xx:xx:xx:xx:xx:xx
>>> Dec  5 10:38:28 surface3 kernel: mwifiex_pcie 0000:01:00.0: info:
>>> associated
>>> to bssid xx:xx:xx:xx:xx:xx successfully
>>> ...
>>> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: Firmware
>>> wakeup
>>> failed
>>
>> As workaround you can disable powersave for wifi (using iw command)
>> and test it should resolve an issue (at least it fixes for me).
>
>
>  13:28:18 up  1:52,
>
> Thanks, so far so good. Are you on a Surface, too?
> Does this also make mwifiex survive a suspend/resume cycle?
> (will try later, when I got work done ;-)
We was struggling with this issue also and found out that disable
powersave resolve issue (as you have maybe a bit higher consumption).
Glad that it helps ;), enjoy. There are some small fixes to avoid this
issue but my theory is that issue is in marvell firmware and this one
needs to be addressed and fixed.
>
> Greetings,
>         Rene
> --
>   Ren=C3=A9 Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10117 Berlin
>   https://exactcode.com | https://t2sde.org | https://rene.rebe.de

BR,

marek

--=20
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
