Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1055 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab1EEMzC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 08:55:02 -0400
Message-ID: <4DC29E18.8070905@broadcom.com> (sfid-20110505_145510_400515_77FD0E2E)
Date: Thu, 5 May 2011 14:54:48 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "Arnd Bergmann" <arnd@arndb.de>,
	"George Kashperko" <george@znau.edu.ua>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	"Russell King" <rmk@arm.linux.org.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Jonas Gorski" <jonas.gorski@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"Greg KH" <greg@kroah.com>, "Andy Botting" <andy@andybotting.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: AXI driver status => previously: Re: Could I (ab)use bus
 (struct bus_type) for virtual Broadcom bus?
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
 <201104171938.12834.arnd@arndb.de> <op.vt6ufu1n3ri7v4@arend-laptop>
 <201104191635.40351.arnd@arndb.de> <op.vt76hofg3ri7v4@arend-laptop>
 <BANLkTinMe-KedeOAiQYES-LCC2O4BoE28w@mail.gmail.com>
 <4DC2991F.6030703@broadcom.com>
 <BANLkTi=4zxFWKymsnZuycMowXJz_ciHuVQ@mail.gmail.com>
In-Reply-To: <BANLkTi=4zxFWKymsnZuycMowXJz_ciHuVQ@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2011 02:48 PM, Rafał Miłecki wrote:
>
> Hey,
>
> I got some unique possibility to work on machine affected by DMA
> errors and I spent last 2 weeks only on solving this issue. I'm going
> to go back to AMBA topic again soo.

Great,

I was spending some time on other stuff as well. I will be picking up 
integrating the module in our brcm80211 driver to get a feel how it fits.

Gr. AvS


