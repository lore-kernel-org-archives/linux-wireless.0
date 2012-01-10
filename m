Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47182 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab2AJE6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 23:58:08 -0500
Received: by iabz25 with SMTP id z25so313184iab.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jan 2012 20:58:07 -0800 (PST)
Message-ID: <4F0BC55C.70509@lwfinger.net> (sfid-20120110_055815_869909_F2CC6ED3)
Date: Mon, 09 Jan 2012 22:58:04 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: lina <lina.lastname@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: modprob b43 not work after hilibernate
References: <4F09AAE5.2080209@gmail.com>	<4F09BEC0.7080702@lwfinger.net>	<4F09C1E2.6020907@gmail.com> <CACna6rxMPnn1DHtMvsHtCG3y=_-sCKgb=L901MV96fj31BZ58A@mail.gmail.com> <4F0A686F.9050802@gmail.com> <4F0B21A7.10009@lwfinger.net> <4F0BBDBB.2060407@gmail.com>
In-Reply-To: <4F0BBDBB.2060407@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 10:25 PM, lina wrote:
> On Tuesday 10,January,2012 01:19 AM, Larry Finger wrote:
>> On 01/08/2012 10:09 PM, lina wrote:
>>> On Monday 09,January,2012 05:44 AM, Rafał Miłecki wrote:
>>>> Does your kernel have
>>>> [PATCH] bcma: support for suspend and resume
>>>> applied?
>>>
>>> I don't know how to check, googled for a while, found some thread, but
>>> did not
>>> find the patch, is it in the kernel.org [patch] part, I thought the [full
>>> source] is already patched?
>>
>> The mainline kernel v3.2-3191-g36e9db2 has that patch.
>
> when I tried to open
> http://www.kernel.org/diff/diffview.cgi?file=/pub/linux/kernel/v3.0/patch-3.2.bz2
>
> diffview is looping on the cached resource:
> /home/httpd/cache/diffview/ZM/ZMxXxIlPZnZ9405Mc9XmGRWFlkM/index
>
> when I googled v3.2-3191-g36e9db2, it leads me to this thread only.
>
> sorry, I am confusing about how to get this patch and make it to patch.
>
> Thanks for your time,

Get the bleeding-edge version of compat-wireless. That will *always* get you the 
latest set of patches.

Larry

