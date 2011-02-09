Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:54775 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab1BIVND (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 16:13:03 -0500
Subject: Re: SSB AI support code ([RFC5/11] SSB propagate core control and
 state ops usage)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: George Kashperko <george@znau.edu.ua>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTi=DV6gnbYfBsXeL6rb3Rz0a+NhgmN04hPY12wLY@mail.gmail.com> (sfid-20110209_215826_571924_FFFFFFFF93EF5AF3)
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <1297262161.18053.26.camel@dev.znau.edu.ua>
	 <AANLkTi=DV6gnbYfBsXeL6rb3Rz0a+NhgmN04hPY12wLY@mail.gmail.com>
	 (sfid-20110209_215826_571924_FFFFFFFF93EF5AF3)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Feb 2011 22:12:56 +0100
Message-ID: <1297285976.9734.15.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-09 at 21:58 +0100, Rafał Miłecki wrote: 
> I don't know, I've doubts about it :/ That flags are quite messy, mask
> for them is 0x3FFC0000. Ideally we should shift it by 14 bits, but
> that would make writing code harder. Maaaaybe... Michael what do you
> think about this?

I have no idea.
I already expressed my opinion on all this stuff.

One thing is for certain: If this is merged, George has to
adopt maintainership.

-- 
Greetings Michael.

