Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:47473 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759425Ab3ICFlV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 01:41:21 -0400
Message-ID: <1378186879.2048.2.camel@joe-AO722> (sfid-20130903_074124_844139_7D1049F8)
Subject: Re: [PATCH v2 13/16] wcn36xx: add wcn36xx.h
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Date: Mon, 02 Sep 2013 22:41:19 -0700
In-Reply-To: <8738pmv4zv.fsf@purkki.adurom.net>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	 <1377248299-21007-14-git-send-email-k.eugene.e@gmail.com>
	 <1377298929.2816.15.camel@joe-AO722> <87ioyjux5w.fsf@purkki.adurom.net>
	 <1378144193.1953.88.camel@joe-AO722> <87bo4av6fj.fsf@purkki.adurom.net>
	 <1378185231.29083.15.camel@joe-AO722> <877geyv5ma.fsf@purkki.adurom.net>
	 <1378186024.2048.0.camel@joe-AO722> <8738pmv4zv.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 08:39 +0300, Kalle Valo wrote:
> >> What does module mean in this context?
> >
> > KBUILD_MODNAME
> 
> Ok, so there's no way to have functionality like ATH6KL_DBG_BOOT which
> prints information from various files during firmware boot. So
> dynamic_debug is not really usable for my work flow.

I'm confused by your response.
Dynamic debug can work with external masks/levels.
What functionality do you think you're missing?

