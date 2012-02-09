Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39817 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab2BIDG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 22:06:29 -0500
Received: by qcqw6 with SMTP id w6so748047qcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 19:06:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F332B69.6090009@gmail.com>
References: <CAG9cJmnuyjxLFe5Wc4okDmOw4ik0aC_vT8xi5rEhfUJGbiczcg@mail.gmail.com>
	<4F32BB6E.1020803@lwfinger.net>
	<CAG9cJmmffGJBpefd5uz6DP=kjdxPPU7K6hrt0SF81hTL04hLCw@mail.gmail.com>
	<4F332B69.6090009@gmail.com>
Date: Thu, 9 Feb 2012 11:06:28 +0800
Message-ID: <CAG9cJm=CM+2tQ1ChQb+Vx5aAyoH4RjL5SbRuai_CmFsiPJXFVQ@mail.gmail.com> (sfid-20120209_040637_146164_3D3B38D5)
Subject: Re: something about compact-wireless
From: lina <lina.lastname@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 9, 2012 at 10:11 AM, Richard Farina <sidhayn@gmail.com> wrote:
> On 02/08/12 21:09, lina wrote:
>> On Thu, Feb 9, 2012 at 2:14 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> On 02/08/2012 11:05 AM, lina wrote:
>>>> Hi,
>>>>
>>>> The question i am going to ask might sounds silly, please forgive,
>>>>
>>>> do I need the compact-wireless in future? something about it's history?
>>>
>>> Obviously, you do not understand the reason for compat-wireless. It is used
>>> to backport the wireless drivers in the development kernels so that they can
>>> be used on older kernels. Whether you need it depends on what kernel you are
>>> using, and what device(s) you have. The short answer is "probably not".
>> Thanks for explaination.
>>
>> last night I installed the $ uname -a
>> Linux debian 3.2.5
>>
>> Do I still need install the compact-wireless?
> if you don't know if you need compat-wireless then you don't need
> compat-wireless.

But I have installed the compat-wireless.

during kernel compilation it showed me:

:/var/lib/dkms/blcr/0.8.2/build# more make.log
DKMS make.log for blcr-0.8.2 for kernel 3.2.5mj-lina (x86_64)
Thu Feb  9 00:35:52 SGT 2012
make: Entering directory `/scratch/staff/linux-source-3.2.5'
/var/lib/dkms/blcr/0.8.2/build/Kbuild:19: /var/lib/dkms/blcr/0.8.2/build/module
_files: No such file or directory
...
configure: error: --with-linux argument '3.2.5mj-lina' is neither a kernel vers
ion string nor a full path
make[1]: *** [/var/lib/dkms/blcr/0.8.2/build/config-stamp] Error 1
make: *** [_module_/var/lib/dkms/blcr/0.8.2/build] Error 2
make: Leaving directory `/scratch/staff/linux-source-3.2.5'

Thanks,

>
> Enjoy.
>
> -Rick
>>
>> Thanks again,
>>
>>> Larry
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
