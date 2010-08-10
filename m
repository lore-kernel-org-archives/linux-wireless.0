Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48776 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756524Ab0HJNi2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 09:38:28 -0400
To: Ameya Palande <ameya.palande@nokia.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"carsten\@maemo.org" <carsten@maemo.org>
Subject: Re: bug: wl1251 stalls connection
References: <1281438628.1964.6.camel@chotu> <4C614988.20106@adurom.com>
	<1281447317.17541.30.camel@chotu>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 10 Aug 2010 16:38:26 +0300
In-Reply-To: <1281447317.17541.30.camel@chotu> (Ameya Palande's message of "Tue\, 10 Aug 2010 16\:35\:17 +0300")
Message-ID: <87sk2mbnal.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ameya Palande <ameya.palande@nokia.com> writes:

> Hi Kalle,

Hi Ameya,

>> I remember Android having similar problems with wl1251_sdio. I'm
>> guessing wl1251 scan commands are somehow broken in upstream kernel.
>> Obviously this was working with maemo kernels.
>> 
>> It would help someone can file a bug about this to
>> https://bugzilla.kernel.org/. Easier to track the issue that way.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=16554

Thanks a lot for filing the bug. I'll keep it up-to-date.

-- 
Kalle Valo
