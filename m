Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:18895 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYLHPfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 10:35:18 -0500
Received: by an-out-0708.google.com with SMTP id d40so474229and.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 07:35:16 -0800 (PST)
Message-ID: <e27b78a40812080735n465186a0s8a43a40817789826@mail.gmail.com> (sfid-20081208_163523_480280_36244A10)
Date: Mon, 8 Dec 2008 15:35:16 +0000
From: Keir <keirlawson@gmail.com>
To: "Andrey Yurovsky" <andrey@cozybit.com>
Subject: Re: Problems with o11s
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45e8e6c40812021127s4db52598n5541ea78f583013e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40812020752o396b2542kfc26b55caeade8df@mail.gmail.com>
	 <45e8e6c40812021127s4db52598n5541ea78f583013e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrey,

Using the commit directly before
dc300b5c5291d779a53d83af960fdf9388bf0544 (I'm pretty sure).  Don't
know how to test IBSS.  I'm guessing the problem  here is the
plink_close messages arent getting through somehow?

Cheers for all your help

Keir

2008/12/2 Andrey Yurovsky <andrey@cozybit.com>:
> Hi Keir.  I believe you're using ath5k?  You can use, at this time, up
> to (but not including) commit
> dc300b5c5291d779a53d83af960fdf9388bf0544, where we have a regression
> in the driver when the PCU-related code was updated.  Have you tried
> testing IBSS mode in your setup?
>
>  -Andrey
>
> On Tue, Dec 2, 2008 at 7:52 AM, Keir <keirlawson@gmail.com> wrote:
>> Hi,
>>
>> I've had o11s working for a while now, but I seem to get a strange problem
>> whereby pinging between MPs works for the first few pings, and then I start
>> getting packet loss (Destination Host Unreachable)  and nothing gets
>> through, despite the other station being listed as "ESTAB" by iw.  I'm not
>> sure if there is something strange about my setup, or this is a bug
>> somewhere, anyone got any ideas? I'm using revision
>> d059b2aed9e93cb94364e01374bca90ce3dc0ef9
>>
>> Cheers
>>
>> Keir
>>
>
