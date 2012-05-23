Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60074 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab2EWK7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2012 06:59:06 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow setting default U-APSD queues/max_sp_len for STA
References: <1337760813-27055-1-git-send-email-arik@wizery.com>
	<87wr436utp.fsf@purkki.adurom.net>
	<CA+XVXfeju02Ou=jZ=eyq+0e4Rm1-5=b6-m8bMyZ8kAWO6F-sXQ@mail.gmail.com>
Date: Wed, 23 May 2012 13:59:04 +0300
In-Reply-To: <CA+XVXfeju02Ou=jZ=eyq+0e4Rm1-5=b6-m8bMyZ8kAWO6F-sXQ@mail.gmail.com>
	(Arik Nemtsov's message of "Wed, 23 May 2012 13:49:22 +0300")
Message-ID: <87mx4z6u4n.fsf@purkki.adurom.net> (sfid-20120523_125925_916046_5102E01E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arik Nemtsov <arik@wizery.com> writes:

> On Wed, May 23, 2012 at 1:44 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> Arik Nemtsov <arik@wizery.com> writes:
>>
>>> Allow the low level driver to set U-APSD parameters when operating in
>>> managed mode.
>>
>> Why? I assume there is a reason for this...
>
> Of course.

Then you could write it down to the commit log instead of forcing others
to ask.

> We want to change this in wlcore. We've encountered compatibility
> problems with some APs when we set ACs other than VO to U-APSD mode.

Sounds like a hack to do this in the driver. Why can't mac80211 do it?

-- 
Kalle Valo
