Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:48630 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab0BPUdU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:33:20 -0500
Received: by bwz5 with SMTP id 5so2345125bwz.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 12:33:18 -0800 (PST)
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] nl80211: add power save commands
References: <20100216201026.25148.40799.stgit@tikku>
	<43e72e891002161219u2916f735l6325f7e7054fa5e2@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 16 Feb 2010 22:33:15 +0200
In-Reply-To: <43e72e891002161219u2916f735l6325f7e7054fa5e2@mail.gmail.com> (Luis R. Rodriguez's message of "Tue\, 16 Feb 2010 12\:19\:58 -0800")
Message-ID: <87ocjohqes.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@gmail.com> writes:

> On Tue, Feb 16, 2010 at 12:10 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> From: Kalle Valo <kalle.valo@nokia.com>
>>
>> The only missing command from nl80211, which Wireless Extensions had,
>> was support for power save mode.
>
> BTW I actually found another which is missing to be complete to wext:
>
> iwconfig wlan0 txpower 17

Oh, good to know. I'll update the commit log to note this.

> I guess I should take care of that since I'm the regulatory dork.

It would be great if you can do that. The faster we can get rid of WE
the better.

-- 
Kalle Valo
