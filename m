Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51346 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219Ab3ICFjD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 01:39:03 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Joe Perches <joe@perches.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Subject: Re: [PATCH v2 13/16] wcn36xx: add wcn36xx.h
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	<1377248299-21007-14-git-send-email-k.eugene.e@gmail.com>
	<1377298929.2816.15.camel@joe-AO722>
	<87ioyjux5w.fsf@purkki.adurom.net>
	<1378144193.1953.88.camel@joe-AO722>
	<87bo4av6fj.fsf@purkki.adurom.net>
	<1378185231.29083.15.camel@joe-AO722>
	<877geyv5ma.fsf@purkki.adurom.net> <1378186024.2048.0.camel@joe-AO722>
Date: Tue, 03 Sep 2013 08:39:00 +0300
In-Reply-To: <1378186024.2048.0.camel@joe-AO722> (Joe Perches's message of
	"Mon, 02 Sep 2013 22:27:04 -0700")
Message-ID: <8738pmv4zv.fsf@purkki.adurom.net> (sfid-20130903_073906_818003_0B6B1B22)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Tue, 2013-09-03 at 08:25 +0300, Kalle Valo wrote:
>> Joe Perches <joe@perches.com> writes:
>> 
>> > Most don't do that.
>> > Generally it's enabled/disabled by module.
>> >
>> >> And enabling log messages on the file level is sometimes too
>> >> much. So it would really need some sort of grouping feature with a
>> >> stable interface.
>> >
>> > Like by module?
>> 
>> What does module mean in this context?
>
> KBUILD_MODNAME

Ok, so there's no way to have functionality like ATH6KL_DBG_BOOT which
prints information from various files during firmware boot. So
dynamic_debug is not really usable for my work flow.

-- 
Kalle Valo
