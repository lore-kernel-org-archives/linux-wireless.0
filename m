Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2634 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1FJQaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 12:30:11 -0400
Message-ID: <4DF24685.3080702@broadcom.com> (sfid-20110610_183015_439659_1BDA9B14)
Date: Fri, 10 Jun 2011 18:29:57 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: =?ISO-8859-2?Q?Michael_B=FCsch?= <m@bues.ch>,
	"=?ISO-8859-2?Q?Rafa=B3_?= =?ISO-8859-2?Q?Mi=B3ecki?="
	<zajec5@gmail.com>, "Michael Buesch" <mb@bu3sch.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] drivers: bcma: export bcma_core_disable() function
References: <1307642840-3043-1-git-send-email-arend@broadcom.com>
 <BANLkTim4p+jjm3iT63Lum146K38iGgvhWw@mail.gmail.com>
 <4DF2042C.6060605@broadcom.com> <20110610133911.36f9f8b2@Nokia-N900>
 <20110610134016.GC2665@tuxdriver.com>
In-Reply-To: <20110610134016.GC2665@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-2;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2011 03:40 PM, John W. Linville wrote:
> On Fri, Jun 10, 2011 at 01:39:11PM +0000, Michael Büsch wrote:
>> On Fri, 10 Jun 2011 13:46:52 +0200
>> "Arend van Spriel"<arend@broadcom.com>  wrote:
>>>> Michael said we should not do do such a exporting without getting
>>>> users within the same patch serie.
>>> That is going to be hard for me despite my willingness to comply. Our
>>> driver is still in staging so we submit our brcm80211 patches to Greg
>>> KH. I figured it would be better to do submit patches for bcma on
>>> wireless repository.
>> There are no rules without exceptions ;-)
> Right, so I don't really mind taking it.  OTOH, maybe Greg could just
> carry the patch in his staging tree...?
>
> John

Thanks, John

I leave it up to Rafa³ and Michael to decide. Both ways are fine by me.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


