Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-out.inet.fi ([195.156.147.13]:41591 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2KYT3e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 14:29:34 -0500
Subject: Re: Atheros AR3012 problem in Ubuntu 12.04LTS
From: Jukka Kivari <jukka.kivari@pohjolantietotekniikka.fi>
Reply-To: jukka.kivari@pohjolantietotekniikka.fi
To: Kalle Valo <kvalo@adurom.com>
Cc: mcgrof@qca.qualcomm.com, linux-wireless@vger.kernel.org
In-Reply-To: <1353870648.2973.9.camel@EDAnovaSRV1>
References: <1353859765.3743.14.camel@EDAnovaSRV1>
	 <87a9u5wraw.fsf@purkki.adurom.net>  <1353870648.2973.9.camel@EDAnovaSRV1>
Content-Type: text/plain
Date: Sun, 25 Nov 2012 21:29:28 +0200
Message-Id: <1353871768.3325.3.camel@EDAnovaSRV1> (sfid-20121125_202941_798825_40363681)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


Exactly the sane problem on Acer machine is described here. It includes
workaround also. The root cause is the same which we figured "New
atheros AR3012`s id is not included in ath3k bluetooth kernel module"

http://www.linlap.com/acer_aspire_s3


*************************************
Bluetooth
The bluetooth module is the new Atheros AR3012, which requires loading a
firmware before it can be used. For now, patching the kernel is required
to recognize this module as AR3012 one.

The patch, and it's upstream progress, can be seen here:
http://thread.gmane.org/gmane.linux.bluez.kernel/18801

New atheros AR3012`s id is not included in ath3k bluetooth kernel
module, you can compile your own kernel using this:

https://lkml.org/lkml/2011/12/4/69

More info:
http://ubuntuforums.org/showthread.php?t=1867447&highlight=zenbook

*************************************

-- 

-Jukka


****************
Powered by Linux
****************

-----Original Message-----
From: Jukka Kivari <jukka.kivari@pohjolantietotekniikka.fi>
Reply-to: jukka.kivari@pohjolantietotekniikka.fi
To: Kalle Valo <kvalo@adurom.com>
Cc: mcgrof@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: Atheros AR3012 problem in Ubuntu 12.04LTS
Date: Sun, 25 Nov 2012 21:10:50 +0200

Hi,

Thanks for quick response.

We are using standard Ubuntu release. We don't have access to Dell
pre-installed version (yet) as it's not available/supported in Finland.
I have asked it from Dell but let's see if we get it or not.

BT isn't working on standard 11.10 Ubuntu either, nor in 12.10.

We haven't tried manual binding yet. We'll check it.



