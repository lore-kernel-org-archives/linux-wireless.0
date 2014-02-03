Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:56743 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaBCNkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 08:40:03 -0500
Received: by mail-qa0-f42.google.com with SMTP id k4so10153594qaq.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 05:40:02 -0800 (PST)
Message-ID: <52EF9C2E.5030202@opensuse.org> (sfid-20140203_144008_789068_4A55BA1A)
Date: Mon, 03 Feb 2014 10:39:58 -0300
From: =?UTF-8?B?Q3Jpc3RpYW4gUm9kcsOtZ3Vleg==?= <crrodriguez@opensuse.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] [iw] Make the build system automake based
References: <1391319050-100614-1-git-send-email-crrodriguez@opensuse.org>	 <1391424732.4488.4.camel@jlt4.sipsolutions.net>	 (sfid-20140203_115223_694753_9E04CB22) <1391424860.4488.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1391424860.4488.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 03/02/14 07:54,  escribió:
> On Mon, 2014-02-03 at 11:52 +0100, Johannes Berg wrote:
>
>> I *might* be open to switching to something like
>> cmake
>
> [...] something *sane* like cmake [...]
>
> (FWIW, don't even argue that part about auto*, it's decidedly not sane
> to have a build system that needs roughly two dozen versions installed
> concurrently to build different software)
>
> johannes
>

Well, unfortunately we disagree on everything. cmake is NOT sane though 
I could write an equivalent in few minutes, read the book, been there, 
done that.. it sucks.

Autotools does not require two dozen versions installed to build 
anything, this is a apparently an insanity found only in debian 
distributions.

Looks like I am going to stop wasting keystrokes about now..people who 
have similar opinions invariably do not understand the problems faced by 
distributors or packagers.


