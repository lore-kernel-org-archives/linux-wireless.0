Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.exactcode.de ([144.76.154.42]:49948 "EHLO mx.exactcode.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752191AbdLEMbS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 07:31:18 -0500
Subject: Re: MWIFIEX still unstable after two years on MS Surface Pro 3
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <d776bc3d-7712-8430-93e2-72e4b6bbf23c@exactcode.com>
 <CAAfyv35EDMmyW_FTJJsNbOweivd=xwDgb=omRA4swQiu4ZXUqQ@mail.gmail.com>
From: =?UTF-8?Q?Ren=c3=a9_Rebe?= <rene@exactcode.com>
Message-ID: <a5d827e7-6846-a903-0b1f-55132ddf2631@exactcode.com> (sfid-20171205_133122_242581_7ABF4A82)
Date: Tue, 5 Dec 2017 13:31:09 +0100
MIME-Version: 1.0
In-Reply-To: <CAAfyv35EDMmyW_FTJJsNbOweivd=xwDgb=omRA4swQiu4ZXUqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marek,

thank you for your blazingly fast reply.

On 12/05/2017 12:41 PM, Belisko Marek wrote:
> Hi Rene,
> 
> On Tue, Dec 5, 2017 at 12:06 PM, René Rebe <rene@exactcode.com> wrote:
>> Hi all,
>>
>> I write to start a discussion about the state of the mwifiex driver.
>> For over two years many other and me wait that the driver finally becomes
>> "stable". However, even with kernel 4.14.2 it still fails after some
>> minutes, or latest after some hours. With various stray errors in the system
>> log:
>>
>> Dec  5 09:50:50 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: MWIFIEX
>> VERSION: mwifiex 1.0 (15.68.7.p119)
>> Dec  5 09:50:50 surface3 kernel: mwifiex_pcie 0000:01:00.0: driver_version =
>> mwifiex 1.0 (15.68.7.p119)
>>
>> Dec  5 10:38:28 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: trying to
>> associate to 'XXX' bssid xx:xx:xx:xx:xx:xx
>> Dec  5 10:38:28 surface3 kernel: mwifiex_pcie 0000:01:00.0: info: associated
>> to bssid xx:xx:xx:xx:xx:xx successfully
>> ...
>> Dec  5 10:42:51 surface3 kernel: mwifiex_pcie 0000:01:00.0: Firmware wakeup
>> failed
> As workaround you can disable powersave for wifi (using iw command)
> and test it should resolve an issue (at least it fixes for me).

  13:28:18 up  1:52,

Thanks, so far so good. Are you on a Surface, too?
Does this also make mwifiex survive a suspend/resume cycle?
(will try later, when I got work done ;-)

Greetings,
	Rene
-- 
   René Rebe, ExactCODE GmbH, Lietzenburger Str. 42, DE-10117 Berlin
   https://exactcode.com | https://t2sde.org | https://rene.rebe.de
