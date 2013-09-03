Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:52688 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759366Ab3ICF1G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 01:27:06 -0400
Message-ID: <1378186024.2048.0.camel@joe-AO722> (sfid-20130903_072709_883446_D5607F28)
Subject: Re: [PATCH v2 13/16] wcn36xx: add wcn36xx.h
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Date: Mon, 02 Sep 2013 22:27:04 -0700
In-Reply-To: <877geyv5ma.fsf@purkki.adurom.net>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	 <1377248299-21007-14-git-send-email-k.eugene.e@gmail.com>
	 <1377298929.2816.15.camel@joe-AO722> <87ioyjux5w.fsf@purkki.adurom.net>
	 <1378144193.1953.88.camel@joe-AO722> <87bo4av6fj.fsf@purkki.adurom.net>
	 <1378185231.29083.15.camel@joe-AO722> <877geyv5ma.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-03 at 08:25 +0300, Kalle Valo wrote:
> Joe Perches <joe@perches.com> writes:
> 
> > Most don't do that.
> > Generally it's enabled/disabled by module.
> >
> >> And enabling log messages on the file level is sometimes too
> >> much. So it would really need some sort of grouping feature with a
> >> stable interface.
> >
> > Like by module?
> 
> What does module mean in this context?

KBUILD_MODNAME


