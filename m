Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37371 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab1EEMsc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 08:48:32 -0400
MIME-Version: 1.0
In-Reply-To: <4DC2991F.6030703@broadcom.com>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
	<201104171938.12834.arnd@arndb.de>
	<op.vt6ufu1n3ri7v4@arend-laptop>
	<201104191635.40351.arnd@arndb.de>
	<op.vt76hofg3ri7v4@arend-laptop>
	<BANLkTinMe-KedeOAiQYES-LCC2O4BoE28w@mail.gmail.com>
	<4DC2991F.6030703@broadcom.com>
Date: Thu, 5 May 2011 14:48:31 +0200
Message-ID: <BANLkTi=4zxFWKymsnZuycMowXJz_ciHuVQ@mail.gmail.com> (sfid-20110505_144848_435551_94069A0E)
Subject: Re: AXI driver status => previously: Re: Could I (ab)use bus (struct
 bus_type) for virtual Broadcom bus?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
	George Kashperko <george@znau.edu.ua>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Russell King <rmk@arm.linux.org.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	Greg KH <greg@kroah.com>, Andy Botting <andy@andybotting.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 5 maja 2011 14:33 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On 04/20/2011 09:29 AM, Rafał Miłecki wrote:
>>
>> I do not register that exceptional devices in my code.
>
> Hi Rafał,
>
> There has been some radio silence on the subject of the (bcm)axi driver. I
> was getting a feeling that my concerns were almost all out of the way in
> latest emails I got from Arnd and/or Jonas. Do you have an update of what
> plans you have with this module.

Hey,

I got some unique possibility to work on machine affected by DMA
errors and I spent last 2 weeks only on solving this issue. I'm going
to go back to AMBA topic again soo.

-- 
Rafał
