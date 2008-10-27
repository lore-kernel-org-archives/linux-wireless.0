Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:32530 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbYJ0BZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Oct 2008 21:25:51 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1885218rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Oct 2008 18:25:50 -0700 (PDT)
Message-ID: <a8e1da0810261825s356ee43ck638487eb14ce3244@mail.gmail.com> (sfid-20081027_022556_818612_85408CF4)
Date: Mon, 27 Oct 2008 09:25:50 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] hang with ath5k
Cc: "Jiri Slaby" <jirislaby@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org,
	"kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200810250040.24324.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <a8e1da0810140142g633486br12c2799b2fa1670e@mail.gmail.com>
	 <48F6133D.1070508@gmail.com>
	 <a8e1da0810152334x6c596f88i1fd74548dc166f3a@mail.gmail.com>
	 <200810250040.24324.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 25, 2008 at 6:40 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, 16 of October 2008, Dave Young wrote:
>> On Wed, Oct 15, 2008 at 11:58 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> > On 10/14/2008 10:42 AM, Dave Young wrote:
>> >> 1) run wpa_supplicant
>> >> 2) ctrl + C
>> >> 3) goto 1)
>> >
>> > It doesn't happen here. How many iterations in average you need to reproduce this?
>> >
>>
>> About 15 times for me,
>> BTW, wpa_gui running while testing
>
> Is this a regression from 2.6.26?

Hi, I don't think so, There's such problem in 2.6.26 as well.

>
> Rafael
>



-- 
Regards
dave
