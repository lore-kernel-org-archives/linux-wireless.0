Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:62517 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbYFWRFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 13:05:07 -0400
To: "Dan Williams" <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Bernhard Reiter <bernhard@intevation.de>,
	linux-wireless@vger.kernel.org, Dave <kilroyd@googlemail.com>
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
References: <200806181715.20516.bernhard@intevation.de>
	<200806191023.39851.bernhard@intevation.de> <485A9A00.70700@gmail.com>
	<200806200935.55882.bernhard@intevation.de>
	<1213947479.8967.134.camel@johannes.berg> <878wwwi0zr.fsf@nokia.com>
	<1214240005.16075.42.camel@localhost.localdomain>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 23 Jun 2008 20:01:02 +0300
In-Reply-To: <1214240005.16075.42.camel@localhost.localdomain> (ext Dan Williams's message of "Mon\, 23 Jun 2008 12\:53\:25 -0400")
Message-ID: <87zlpcgk6p.fsf@nokia.com> (sfid-20080623_190538_434301_7AA0D849)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams <dcbw@redhat.com> writes:

>> > Just FYI, there are patches in the queue that will most likely make all
>> > (out-of-tree) drivers using wireless extensions break, so even if it
>> > works now it will probably not with 2.6.27.
>> 
>> What is breaking out-of-tree drivers in 2.6.27? David Miller's compat
>> WEXT stuff, or what?
>
> Yes.

Thanks for the clarification. I'll be prepared now.

-- 
Kalle Valo
