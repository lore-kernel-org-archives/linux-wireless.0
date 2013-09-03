Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:59114 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356Ab3ICFsM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 01:48:12 -0400
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
	<8738pmv4zv.fsf@purkki.adurom.net> <1378186879.2048.2.camel@joe-AO722>
Date: Tue, 03 Sep 2013 08:48:10 +0300
In-Reply-To: <1378186879.2048.2.camel@joe-AO722> (Joe Perches's message of
	"Mon, 02 Sep 2013 22:41:19 -0700")
Message-ID: <87y57etq05.fsf@purkki.adurom.net> (sfid-20130903_074815_368411_0BDE303C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Tue, 2013-09-03 at 08:39 +0300, Kalle Valo wrote:
>> >> What does module mean in this context?
>> >
>> > KBUILD_MODNAME
>> 
>> Ok, so there's no way to have functionality like ATH6KL_DBG_BOOT which
>> prints information from various files during firmware boot. So
>> dynamic_debug is not really usable for my work flow.
>
> I'm confused by your response.
> Dynamic debug can work with external masks/levels.
> What functionality do you think you're missing?

I was just replying to your question why I think dynamic_debug is not
usable in wifi drivers.

-- 
Kalle Valo
