Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:53929 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab1BIWCp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 17:02:45 -0500
Subject: Re: SSB AI support code ([RFC4/11] SSB core control and state
 device ops)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=4TTXEQf-ECRBQTBqv-K5u+9yMke88vpwgrmnG@mail.gmail.com> (sfid-20110209_225600_481400_24506838)
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <1297262089.18053.24.camel@dev.znau.edu.ua>
	 <AANLkTinC+ijSG=qzzk9OWLGRLsxM0dm12YkERxKbwg6t@mail.gmail.com>
	 <1297285438.11767.28.camel@dev.znau.edu.ua>
	 <AANLkTi=4TTXEQf-ECRBQTBqv-K5u+9yMke88vpwgrmnG@mail.gmail.com>
	 (sfid-20110209_225600_481400_24506838)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 23:02:39 +0100
Message-ID: <1297288959.9734.31.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-09 at 22:55 +0100, Rafał Miłecki wrote: 
> I aksed about reading, you gave me examples of writing. I want to
> avoid such a non-readable disasters:
> u32 tmp;
> ssb_core_ctl_flags(dev, 0, 0, &tmp);

A good function name consists of:
"WHAT is done and WHERE is it done"

ssb_core_ctl_flags()
violates both of them. It doesn't specify what is done at all,
except that it might be something random with ctl flags.
And it lies about where it does it. It implies that it operates
on SSB. However, it might operate on SSB or AI.

-- 
Greetings Michael.

