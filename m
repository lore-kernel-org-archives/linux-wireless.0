Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4153 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab1FJLrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 07:47:06 -0400
Message-ID: <4DF2042C.6060605@broadcom.com> (sfid-20110610_134716_465980_19525A39)
Date: Fri, 10 Jun 2011 13:46:52 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Michael Buesch" <mb@bu3sch.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] drivers: bcma: export bcma_core_disable() function
References: <1307642840-3043-1-git-send-email-arend@broadcom.com>
 <BANLkTim4p+jjm3iT63Lum146K38iGgvhWw@mail.gmail.com>
In-Reply-To: <BANLkTim4p+jjm3iT63Lum146K38iGgvhWw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2011 01:40 PM, Rafał Miłecki wrote:
> 2011/6/9 Arend van Spriel<arend@broadcom.com>:
>> In the brcm80211 driver we disable the 80211 core when the driver is
>> 'down'. The bcma_core_disable() function exactly does the same as
>> our implementation so exporting this function makes sense.
> Michael said we should not do do such a exporting without getting
> users within the same patch serie.

Hi Rafał,

That is going to be hard for me despite my willingness to comply. Our 
driver is still in staging so we submit our brcm80211 patches to Greg 
KH. I figured it would be better to do submit patches for bcma on 
wireless repository.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


