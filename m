Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37544 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab2BICMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 21:12:14 -0500
Received: by qcqw6 with SMTP id w6so730340qcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 18:12:13 -0800 (PST)
Message-ID: <4F332B69.6090009@gmail.com> (sfid-20120209_031217_742663_A4B7378B)
Date: Wed, 08 Feb 2012 21:11:53 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: lina <lina.lastname@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: something about compact-wireless
References: <CAG9cJmnuyjxLFe5Wc4okDmOw4ik0aC_vT8xi5rEhfUJGbiczcg@mail.gmail.com> <4F32BB6E.1020803@lwfinger.net> <CAG9cJmmffGJBpefd5uz6DP=kjdxPPU7K6hrt0SF81hTL04hLCw@mail.gmail.com>
In-Reply-To: <CAG9cJmmffGJBpefd5uz6DP=kjdxPPU7K6hrt0SF81hTL04hLCw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/12 21:09, lina wrote:
> On Thu, Feb 9, 2012 at 2:14 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 02/08/2012 11:05 AM, lina wrote:
>>> Hi,
>>>
>>> The question i am going to ask might sounds silly, please forgive,
>>>
>>> do I need the compact-wireless in future? something about it's history?
>>
>> Obviously, you do not understand the reason for compat-wireless. It is used
>> to backport the wireless drivers in the development kernels so that they can
>> be used on older kernels. Whether you need it depends on what kernel you are
>> using, and what device(s) you have. The short answer is "probably not".
> Thanks for explaination.
>
> last night I installed the $ uname -a
> Linux debian 3.2.5
>
> Do I still need install the compact-wireless?
if you don't know if you need compat-wireless then you don't need
compat-wireless.

Enjoy.

-Rick
>
> Thanks again,
>
>> Larry
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

