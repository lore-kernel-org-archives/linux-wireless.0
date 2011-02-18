Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52488 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1BRXqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 18:46:14 -0500
Received: by vws16 with SMTP id 16so2325174vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 15:46:14 -0800 (PST)
Message-ID: <4D5F04C0.4080707@lwfinger.net>
Date: Fri, 18 Feb 2011 17:46:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
CC: George Kashperko <george@znau.edu.ua>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	driverdevel <devel@driverdev.osuosl.org>,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>
Subject: Re: [RFC] AI support (13/14 ssb add AI support)
References: <1297958316.5623.27.camel@dev.znau.edu.ua>	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>	 <1297981882.23381.38.camel@dev.znau.edu.ua>	 (sfid-20110217_233956_707110_FFFFFFFFBE33FFA6)  <1298069145.23801.29.camel@maggie>	 <1298070443.25739.23.camel@dev.znau.edu.ua>	 (sfid-20110219_001605_010946_FFFFFFFFA70C4DCA) <1298071637.23801.40.camel@maggie>
In-Reply-To: <1298071637.23801.40.camel@maggie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/18/2011 05:27 PM, Michael Büsch wrote:
> On Sat, 2011-02-19 at 01:07 +0200, George Kashperko wrote:
>> Starting from the clean page means another months of no support for
>> AI-based hw.
>
> Oh, wait a second right here. That's not how Linux development works.
> We want the technically superior solution, not just something that
> works to get stuff working no matter what.
>
> If your patchset works, that's pretty cool. So thanks a lot for getting
> something to the users that works. Nothing stops distributions from
> picking up those patches and distributing it to endusers.
> That doesn't mean we have to adopt it to the mainline, though.

I don't want to get involved in the debate over abstraction, but FWIW, the 
patchset does work for PCI-based SSB devices.

Larry
