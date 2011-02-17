Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:36724 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab1BQWA0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:00:26 -0500
Subject: Re: [RFC] How to rename SSB_TMSLOW_*, B43_TMSLOW_*?
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
In-Reply-To: <AANLkTi=sVaeizU3xJQQwwKXB5saPgdn9VxNQv0-aoiV7@mail.gmail.com> (sfid-20110217_131436_086343_78318A6B)
References: <AANLkTimKE+WqChVf0XpeHsfHxT8=3vbnBh=Lo+1tLSwj@mail.gmail.com>
	 <1297894657.32237.2.camel@maggie>
	 <AANLkTi=sVaeizU3xJQQwwKXB5saPgdn9VxNQv0-aoiV7@mail.gmail.com>
	 (sfid-20110217_131436_086343_78318A6B)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 23:00:18 +0100
Message-ID: <1297980018.13554.4.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-17 at 13:14 +0100, Rafał Miłecki wrote: 
> That's why I wanted to introduce some SSBAI_CORECTL_FOOBAR and make
> b43 unaware it that flags are going to be written in register A or B.
> I wanted b43 to just pass flags to correct function and do not care
> about place where they are getting written.

Ok, well. That's basically what I am talking about for several
days now.

1) Keep SSB and AI separated.
2) Introduce an additional thin layer on top of this to abstract the
bus to the drivers.

-- 
Greetings Michael.

