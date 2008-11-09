Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22782 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYKIOAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 09:00:35 -0500
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: iwconfig power timeout
References: <87tzaiwn3z.fsf@nokia.com> <1226140536.3610.2.camel@johannes.berg>
	<87prl6wk73.fsf@nokia.com> <1226142620.3610.6.camel@johannes.berg>
	<1ba2fa240811081154y4090c8cbk57cd9d975e86df1f@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 09 Nov 2008 16:00:03 +0200
In-Reply-To: <1ba2fa240811081154y4090c8cbk57cd9d975e86df1f@mail.gmail.com> (ext Tomas Winkler's message of "Sat\, 8 Nov 2008 21\:54\:44 +0200")
Message-ID: <878wrt2e58.fsf@nokia.com> (sfid-20081109_150051_132404_6BBF6DBB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

>>> I'm going
>>> to investigate this with gdb and try to understand how iwconfig really
>>> parses the arguments.
>>
>> Well there is source code too ;)
>
> There bugs in command parsing in v29 grab v30 beta where this bugs
> are fixed.

Thanks, v30 beta indeed had a fix for this. It's working now for me.

-- 
Kalle Valo
