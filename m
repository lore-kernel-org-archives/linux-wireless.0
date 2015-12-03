Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58002 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbbLCPJz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 10:09:55 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wlan0: set_features() failed (-1); wanted 0x0000000000004008, left 0x0000000000004808
References: <87bna8f1si.fsf@kamboji.qca.qualcomm.com>
	<CALhHN=pXxEvY4wZcaQ8EL9jNgCy-sC97RwiO7PgaNVfKEO1FGw@mail.gmail.com>
	<1449133427.2181.5.camel@sipsolutions.net>
Date: Thu, 03 Dec 2015 17:09:48 +0200
In-Reply-To: <1449133427.2181.5.camel@sipsolutions.net> (Johannes Berg's
	message of "Thu, 03 Dec 2015 10:03:47 +0100")
Message-ID: <87poynefgj.fsf@kamboji.qca.qualcomm.com> (sfid-20151203_160958_994272_D75ADDF7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2015-12-03 at 09:03 +0100, Janusz Dziedzic wrote:
>> 
>> Missing:
>> net: fix feature changes on devices without ndo_set_features ?
>> 
>
> According to the *code* that's there, but maybe Kalle hasn't recompiled
> it to the latest tree quite right?

Actually I was too hasty when reading the logs and missed that I haven't
seen these warnings since November 30th or so. I guess during after the
patch above trickled down to wireless-testing and fixed the issue.

So everything is good, sorry for the noise.

-- 
Kalle Valo
