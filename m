Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35173 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbcFURdM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 13:33:12 -0400
Received: by mail-ob0-f170.google.com with SMTP id c3so32802867obc.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2016 10:33:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160621165837.dctu6i75lsg7onzn@pirotess>
References: <20160621001841.5383-1-ismael@iodev.co.uk> <CACna6ry-0ZO_JRm976APtRoPXqgMYEh4UrLK+SH0vVV21dX+wQ@mail.gmail.com>
 <20160621165837.dctu6i75lsg7onzn@pirotess>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 21 Jun 2016 19:27:45 +0200
Message-ID: <CACna6rzUdcvMo9jqE9MXUg6fOw_Xn=iyvG3FHKGWm6axZUmZGw@mail.gmail.com> (sfid-20160621_193402_355120_1D1DED4F)
Subject: Re: [PATCH] brcmfmac: Add USB ID for Cisco Linksys AE1200
To: Ismael Luceno <ismael@iodev.co.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 June 2016 at 18:58, Ismael Luceno <ismael@iodev.co.uk> wrote:
> On 21/Jun/2016 07:45, Rafał Miłecki wrote:
>> On 21 June 2016 at 02:18, Ismael Luceno <ismael@iodev.co.uk> wrote:
>> > @@ -56,6 +57,8 @@
>> >
>> >  /* USB Device IDs */
>> >  #define BRCM_USB_43143_DEVICE_ID       0xbd1e
>> > +#define BRCM_USB_43235_LINKSYS_DEVICE_ID \
>> > +                                       0x0039
>>
>> I guess you wanted to have number aligned to the column of other ones?
>> I'm not sure if that improves readability at all.
>
> Yes. Would you suggest to align more to the right? I didn't want to
> modify everything just to add a new one.

I wouldn't care that much about alignment. I'm sure there already some
misaligned numbers, fields & comments in brcm80211 header.

I would just use name\t0x0039 pattern.

-- 
Rafał
