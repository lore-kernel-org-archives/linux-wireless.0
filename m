Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37027 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2AJFT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 00:19:26 -0500
Received: by ghbg21 with SMTP id g21so1965405ghb.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 21:19:26 -0800 (PST)
Message-ID: <4F0BCA5A.1090101@gmail.com> (sfid-20120110_061931_555437_AF4D9257)
Date: Tue, 10 Jan 2012 13:19:22 +0800
From: lina <lina.lastname@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: modprob b43 not work after hilibernate
References: <4F09AAE5.2080209@gmail.com>	<4F09BEC0.7080702@lwfinger.net>	<4F09C1E2.6020907@gmail.com> <CACna6rxMPnn1DHtMvsHtCG3y=_-sCKgb=L901MV96fj31BZ58A@mail.gmail.com> <4F0A686F.9050802@gmail.com> <4F0B21A7.10009@lwfinger.net> <4F0BBDBB.2060407@gmail.com> <4F0BC55C.70509@lwfinger.net>
In-Reply-To: <4F0BC55C.70509@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 10,January,2012 12:58 PM, Larry Finger wrote:
> On 01/09/2012 10:25 PM, lina wrote:
>> On Tuesday 10,January,2012 01:19 AM, Larry Finger wrote:
>>> On 01/08/2012 10:09 PM, lina wrote:
>>>> On Monday 09,January,2012 05:44 AM, Rafał Miłecki wrote:
>>>>> Does your kernel have
>>>>> [PATCH] bcma: support for suspend and resume
>>>>> applied?
>>>>
>>>> I don't know how to check, googled for a while, found some thread, but
>>>> did not
>>>> find the patch, is it in the kernel.org [patch] part, I thought the
>>>> [full
>>>> source] is already patched?
>>>
>>> The mainline kernel v3.2-3191-g36e9db2 has that patch.
>>
>> when I tried to open
>> http://www.kernel.org/diff/diffview.cgi?file=/pub/linux/kernel/v3.0/patch-3.2.bz2
>>
>>
>> diffview is looping on the cached resource:
>> /home/httpd/cache/diffview/ZM/ZMxXxIlPZnZ9405Mc9XmGRWFlkM/index
>>
>> when I googled v3.2-3191-g36e9db2, it leads me to this thread only.
>>
>> sorry, I am confusing about how to get this patch and make it to patch.
>>
>> Thanks for your time,
>
> Get the bleeding-edge version of compat-wireless. That will *always* get
> you the latest set of patches.

Thanks, I just installed the compat-wireless-2012-01-09.tar.bz2

will keep update.
>
> Larry
>

