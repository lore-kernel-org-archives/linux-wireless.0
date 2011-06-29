Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:38871 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab1F2WOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 18:14:37 -0400
Received: by gwaa18 with SMTP id a18so643141gwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 15:14:36 -0700 (PDT)
Message-ID: <4E0BA3C8.6050000@upr.edu> (sfid-20110630_001439_136209_0B9A2FDD)
Date: Wed, 29 Jun 2011 18:14:32 -0400
From: Omar Abraham <omar.abraham@upr.edu>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Alex <alex9434@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Compile error in carl9170 on Debian Squeeze
References: <BANLkTimsGJo61eLp3NrVtDkh0m3CN3zDxw@mail.gmail.com> <4E0B8A61.8090600@upr.edu> <4E0B8E35.8080203@gnu.org> <4E0B9E43.3040209@upr.edu> <4E0BA17E.2020705@gnu.org>
In-Reply-To: <4E0BA17E.2020705@gnu.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Point taken, thanks for your efforts
On 6/29/2011 6:04 PM, Pavel Roskin wrote:
> On 06/29/2011 05:50 PM, Omar Abraham wrote:
>> Is that so? thanks, will be looking it up whenever you have it available
>> On 6/29/2011 4:42 PM, Pavel Roskin wrote:
>>> On 06/29/2011 04:26 PM, Omar Abraham wrote:
>>>> You are using older kernel headers, most likely that could be the
>>>> problem
>>>
>>> No, Debian backports netdev_name in 2.6.32. The fix is to define
>>> netdev_name as a macro in compat-wireless. The same issue was already
>>> reported today, and I'm about to send a patch.
>
> Please don't drop the mailing list from the headers.  It's impolite 
> towards other mailing list members to take the discussion private.
>
> The patch is already here:
> http://marc.info/?l=linux-wireless&m=130938043926323&w=2
>
>

