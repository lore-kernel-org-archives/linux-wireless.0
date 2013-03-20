Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4144 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab3CTRk5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 13:40:57 -0400
Message-ID: <5149F494.3070809@broadcom.com> (sfid-20130320_184102_589173_B47311AB)
Date: Wed, 20 Mar 2013 10:40:36 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Hammad Malik" <hammadmlk@gmail.com>
cc: linux-wireless@vger.kernel.org
Subject: Re: Wifi rate adaption code in Broadcom
References: <CACx7Z0cjMF=hwwV5zz5bDRBb9EPA1_Jt2hJ_5_MpNnbdOLKUGg@mail.gmail.com>
 <CACx7Z0dkpB3s6_utFCGrGjVvqUFG9v-h6p0eNHbMuhEu3RjjYA@mail.gmail.com>
 <CACx7Z0cOySXrDOB6f3z=J83KrOcsFeRGtUYZi3hF+9Z3wpxFRg@mail.gmail.com>
In-Reply-To: <CACx7Z0cOySXrDOB6f3z=J83KrOcsFeRGtUYZi3hF+9Z3wpxFRg@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/19/2013 08:13 PM, Hammad Malik wrote:
> In BCM4330 where is the WiFi rate adaption code?
>
> Depending on the chipset and functionality of specific algorithms,
> rate adaption tends to be implemented either in the firmware or the
> device drivers. But I was not able to exactly determine where this
> happens in the case of BCM4330.

4330 is a fullmac dongle so this happens in the firmware.

-Franky

