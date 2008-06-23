Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:58925 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbYFWQN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 12:13:59 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Bernhard Reiter <bernhard@intevation.de>,
	linux-wireless@vger.kernel.org, Dave <kilroyd@googlemail.com>
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
References: <200806181715.20516.bernhard@intevation.de>
	<200806191023.39851.bernhard@intevation.de> <485A9A00.70700@gmail.com>
	<200806200935.55882.bernhard@intevation.de>
	<1213947479.8967.134.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 23 Jun 2008 19:12:40 +0300
In-Reply-To: <1213947479.8967.134.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 20 Jun 2008 09\:37\:58 +0200")
Message-ID: <878wwwi0zr.fsf@nokia.com> (sfid-20080623_181408_490602_0097F16E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Johannes Berg" <johannes@sipsolutions.net> writes:

>> > Both versions can be found at <http://www.xs4all.nl/~pptp/agere>, which
>> > also has patched versions for 2.6
>> 
>> Cool!
>> Just to make sure: This is a driver that - despite being unmaintained - should 
>> work? So could try it with 2.6.17, 2.6.24 and even newer?
>
> Just FYI, there are patches in the queue that will most likely make all
> (out-of-tree) drivers using wireless extensions break, so even if it
> works now it will probably not with 2.6.27.

What is breaking out-of-tree drivers in 2.6.27? David Miller's compat
WEXT stuff, or what?

Sorry, but it seems that I completely missed this. I should read
mailing lists more carefully.

-- 
Kalle Valo
