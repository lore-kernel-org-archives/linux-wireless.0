Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:61946 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2BICJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 21:09:47 -0500
Received: by qafk1 with SMTP id k1so852913qaf.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 18:09:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F32BB6E.1020803@lwfinger.net>
References: <CAG9cJmnuyjxLFe5Wc4okDmOw4ik0aC_vT8xi5rEhfUJGbiczcg@mail.gmail.com>
	<4F32BB6E.1020803@lwfinger.net>
Date: Thu, 9 Feb 2012 10:09:46 +0800
Message-ID: <CAG9cJmmffGJBpefd5uz6DP=kjdxPPU7K6hrt0SF81hTL04hLCw@mail.gmail.com> (sfid-20120209_031012_517705_1C28EF8F)
Subject: Re: something about compact-wireless
From: lina <lina.lastname@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 9, 2012 at 2:14 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 02/08/2012 11:05 AM, lina wrote:
>>
>> Hi,
>>
>> The question i am going to ask might sounds silly, please forgive,
>>
>> do I need the compact-wireless in future? something about it's history?
>
>
> Obviously, you do not understand the reason for compat-wireless. It is used
> to backport the wireless drivers in the development kernels so that they can
> be used on older kernels. Whether you need it depends on what kernel you are
> using, and what device(s) you have. The short answer is "probably not".

Thanks for explaination.

last night I installed the $ uname -a
Linux debian 3.2.5

Do I still need install the compact-wireless?

Thanks again,

>
> Larry
>
