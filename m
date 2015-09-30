Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbbI3P1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 11:27:18 -0400
Message-ID: <1443626838.9620.23.camel@redhat.com> (sfid-20150930_172729_668039_E2D2C3B9)
Subject: Re: ipw2200-bss
From: Dan Williams <dcbw@redhat.com>
To: Aaron Kempf <aaronwa2014@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 30 Sep 2015 10:27:18 -0500
In-Reply-To: <CAA-9J5EWhy6y8G-DzZPEHCSsVpsrML2N018idBe1Gj=OV4Ba+g@mail.gmail.com>
References: <CAA-9J5EWhy6y8G-DzZPEHCSsVpsrML2N018idBe1Gj=OV4Ba+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-30 at 15:21 +0000, Aaron Kempf wrote:
> I am a tiny bit confused why this 'centrino' driver isn't in the 650mb
> cd download for Debian 8.2

The driver is included in the kernel, so it should be there already.
What may not be included on the CD is the firmware, which you may have
to install later.  It's supposedly in the "firmware-ipw2x00" package.

See also: https://wiki.debian.org/ipw2200

Dan

> I detest Ubuntu in all flavors.. and if you guys would get this driver
> into the Debian kernel, and on the default CD installer.. it would
> make my life a lot easier.
> 
> I wish I could help to do this.. but I am a lowly DBA tryng to get
> deeper into Linux / Debian / BSD.
> 
> Please call me if you could help me to transfer this from a Xubuntu
> 15.04 usb device onto my 8.2 installed system.  I would really
> appreciate it.
> 
> Aaron Kempf
> Microsoft Certified IT Professional: DBA
> Voice: 415-786-0776
> 
> PS - if you guys know of any DBA jobs in San Francisco.. I know my way
> around SQL to say the least :) http://www.fullstackaaron.com/resume
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


