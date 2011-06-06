Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1596 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab1FFKJ5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 06:09:57 -0400
Message-ID: <4DECA76C.90000@broadcom.com> (sfid-20110606_121004_824717_E0FF15BD)
Date: Mon, 6 Jun 2011 12:09:48 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Hauke Mehrtens" <hauke@hauke-m.de>,
	"Arnd Bergmann" <arnd@arndb.de>, "Greg KH" <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"mb@bu3sch.de" <mb@bu3sch.de>,
	"george@znau.edu.ua" <george@znau.edu.ua>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"bernhardloos@googlemail.com" <bernhardloos@googlemail.com>
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
 <1307311658-15853-2-git-send-email-hauke@hauke-m.de>
 <BANLkTimAPHPcqKKJ+Rphef_+1RB0aHR4ug@mail.gmail.com>
In-Reply-To: <BANLkTimAPHPcqKKJ+Rphef_+1RB0aHR4ug@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/06/2011 11:42 AM, Rafał Miłecki wrote:
> Greg, Arnd: could you take a look at this patch, please?
>
> With proposed patch we are going back to this ugly array and wrappers hacks.
>
> I was really happy with our final solution, but it seems it's not
> doable for embedded systems...? Is there something better we can do
> about this?

I do agree with Rafał that we should look for another alternative. I 
posted a suggestion earlier regarding this patch. Can anyone tell me 
whether that could prevent need for the array/wrapper hack.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


