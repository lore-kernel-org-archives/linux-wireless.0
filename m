Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:28714 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757727AbYG0Voo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 17:44:44 -0400
Received: by an-out-0708.google.com with SMTP id d40so859646and.103
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jul 2008 14:44:43 -0700 (PDT)
Message-ID: <52d4a3890807271444v230162f2q16a81a8a03810c14@mail.gmail.com> (sfid-20080727_234450_410175_8CC0E804)
Date: Mon, 28 Jul 2008 00:44:43 +0300
From: "Mohammed Gamal" <m.gamal005@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Fw: [Oops] b43 driver on 2.6.26
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <488CE95B.2090606@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080727135840.a040e368.akpm@linux-foundation.org>
	 <52d4a3890807271402n792dbaces52555f545a7bfa46@mail.gmail.com>
	 <488CE95B.2090606@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 28, 2008 at 12:32 AM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> Mohammed Gamal wrote:
>>
>> On Sun, Jul 27, 2008 at 11:58 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>>
>>> Begin forwarded message:
>>>
>>> Date: Wed, 23 Jul 2008 01:03:24 +0300
>>> From: "Mohammed Gamal" <m.gamal005@gmail.com>
>>> To: linux-net@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Subject: [Oops] b43 driver on 2.6.26
>>>
>>>
>>> I get the following oops with b43 driver on scanning for wireless
>>> networks.
>>> ----
>>> [...]
>>
>> Ignore this, I'm no longer getting this oops on the latest git tree.
>
> This message came from a BUG_ON statement in __netif_schedule(). A
> subsequent
> commit changed it to a WARN_ON, and finally commit 5b3ab1d removed it
> completely
> as the tested condition was essentially harmless.
>
> You should be aware that wireless has not worked since commit
> 175f9c1bba9b825d22b142. See the thread at
> http://www.ussg.iu.edu/hypermail/linux/kernel/0807.3/0936.html for details.
> This problem is not yet formally entered at bugzilla as a regression.
>
> Larry
>

Actually wireless is *partially* working for me. It seems that there's
a lot of packet loss though.
