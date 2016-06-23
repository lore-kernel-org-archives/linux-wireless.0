Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:33614 "EHLO
	mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbcFWIeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 04:34:13 -0400
Received: by mail-oi0-f47.google.com with SMTP id u201so59825587oie.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jun 2016 01:34:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5500469A22567C4BAF673A6E86AFA3A4022D2BB5ED4D@IR-CENTRAL.corp.innerrange.com>
References: <5500469A22567C4BAF673A6E86AFA3A4022D2BB5ED27@IR-CENTRAL.corp.innerrange.com>
 <CACna6ryKgMTYbbGRNw4zPDTvz8W3mKENza+vnhE=tSRYRtZ4kA@mail.gmail.com> <5500469A22567C4BAF673A6E86AFA3A4022D2BB5ED4D@IR-CENTRAL.corp.innerrange.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Thu, 23 Jun 2016 10:34:11 +0200
Message-ID: <CACna6rz7Zt4GMKjHRBAhvhuKfHUnaq-=Km5V9d+c0R6Wmhpoqw@mail.gmail.com> (sfid-20160623_103419_145294_905A0899)
Subject: Re: rt2800usb maintainer/expert?
To: Craig McQueen <craig.mcqueen@innerrange.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 June 2016 at 08:26, Craig McQueen <craig.mcqueen@innerrange.com> wrote:
> Rafał Miłecki wrote:
>> On 23 June 2016 at 07:44, Craig McQueen <craig.mcqueen@innerrange.com>
>> wrote:
>> > I'm interested to talk to an expert with the problems I'm seeing, but not
>> sure who is the expert these days.
>>
>> And that has to be done in private, because...?
>
> Not at all; it would be great to have some help on this mailing list. I'm struggling to resolve a rt2800usb driver issue, and I've asked a few questions about it on this list. Any help would be greatly appreciated, since I'm struggling with this complex area of the kernel code (I'm comfortable writing Linux drivers, but debugging Wi-Fi and USB issues is new to me.)

Oh, I had to forgot about your e-mails then. If there is someone
interested in the driver, he probably follows linux-wireless@. You can
also take a look at MAINTAINERS or just use
./scripts/get_maintainer.pl -f drivers/net/wireless/ralink/rt2x00/

-- 
Rafał
