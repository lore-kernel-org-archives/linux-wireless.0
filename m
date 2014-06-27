Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:44651 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaF0SuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 14:50:23 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so3302155wib.7
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2014 11:50:22 -0700 (PDT)
Message-ID: <53ADBCE7.5020402@gmail.com> (sfid-20140627_205026_643495_CB9AF98B)
Date: Fri, 27 Jun 2014 19:50:15 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/17] staging: vt6656: conversion to mac80211
References: <1403727278-6666-1-git-send-email-tvboxspy@gmail.com> <1403764178.4131.5.camel@jlt4.sipsolutions.net> <20140627002052.GA26828@kroah.com>
In-Reply-To: <20140627002052.GA26828@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/06/14 01:20, Greg KH wrote:
> On Thu, Jun 26, 2014 at 08:29:38AM +0200, Johannes Berg wrote:
>> On Wed, 2014-06-25 at 21:14 +0100, Malcolm Priestley wrote:
>>> The patches in this series convert the driver to mac80211.
>>
>> Impressive! I didn't think it was actually *possible* to convert a
>> driver, I used to think a rewrite with selective copy/pasting would be
>> the right approach :-)
>
> I agree, very nice job with all of this, great to see this happen.
>

Thanks all,

It's taken a while to convert to driver but interesting.

Still a little more work needs doing and hopefully get this driver out
of staging.



Malcolm
