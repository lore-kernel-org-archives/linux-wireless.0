Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4938 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab3GXU5P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 16:57:15 -0400
Message-ID: <51F03F9C.10005@broadcom.com> (sfid-20130724_225722_222065_1A15E2B7)
Date: Wed, 24 Jul 2013 22:57:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Jordan McCarthy" <mccarthy@opentechinstitute.org>
cc: linux-wireless@vger.kernel.org
Subject: Re: IBSS-RSN support for BCM4313
References: <51EFC944.40502@opentechinstitute.org>
In-Reply-To: <51EFC944.40502@opentechinstitute.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/24/2013 02:32 PM, Jordan McCarthy wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Hi Linux wireless folk,
> 	I am a developer at a non-profit working on a wireless mesh networking
> platform, and we've just discovered that we have a fleet of netbooks
> with the Broadcom 4313 chipset, one that does not work particularly well
> (and sometimes not at all) in ad-hoc mode.

For certain variants of that chipset the brcmsmac driver does not 
perform well regardless the mode it is in. So could you provide some 
more details on the bcm4313 chipset. Can you provide contents from 
/sys/kernel/debug/brcmsmac/bcma*/hardware (if that is the correct path).

Regards,
Arend

