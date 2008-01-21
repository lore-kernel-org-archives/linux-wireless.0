Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:57245 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbYAUGd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 01:33:28 -0500
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: "bruno randolf" <br1@einfach.org>, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH 2/4] ath5k: always extend rx timestamp with tsf
References: <46274.61.115.136.26.1200807429.squirrel@webmail.einfach.org>
	<43e72e890801200046n2c858c97k3506664431b937e6@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 21 Jan 2008 08:32:48 +0200
In-Reply-To: <43e72e890801200046n2c858c97k3506664431b937e6@mail.gmail.com> (ext Luis R. Rodriguez's message of "Sun\, 20 Jan 2008 03\:46\:05 -0500")
Message-ID: <87tzl7g033.fsf@nokia.com> (sfid-20080121_063331_233853_767E3B75)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@winlab.rutgers.edu> writes:

>> what i mean
>> is 32768us equals about 32ms. i'll remove that dot to make it unambigous.
>
> Yeah thanks, might be more clear for those of us not used to that
> convention, I didn't even know it existed. Where is this "." for 1000
> notation convention used, just so I know :) ?

It seems most of Europe uses it, even though we Finns don't:

"In much of Europe, however, a comma is used as a decimal separator,
while a full stop or a space is used for the presentation of large
numbers:

        * 1.000.000 (One million)
        * 1.000,000 or 1 000,000 (One thousand)"

http://en.wikipedia.org/wiki/Full_stop#Mathematical_usage

-- 
Kalle Valo
