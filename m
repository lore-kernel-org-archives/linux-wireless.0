Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57143 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1DJQSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 12:18:14 -0400
Received: by iwn34 with SMTP id 34so4895033iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 09:18:13 -0700 (PDT)
Message-ID: <4DA1D842.2060006@lwfinger.net>
Date: Sun, 10 Apr 2011 11:18:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Firmware files for Ralink RT28x0
References: <1302450962.5282.129.camel@localhost>
In-Reply-To: <1302450962.5282.129.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2011 10:56 AM, Ben Hutchings wrote:
> I notice that rt2800{pci,usb} each specify only one firmware image,
> regardless of the controller version.
>
> This is inconsistent with rt28{6,7}0sta and with the firmware images in
> linux-firmware.
>
> If you think that a single image per bus type can cover all controllers,
> please identify those firmware images, test them on each hardware
> generation, and get them into linux-firmware.

With rt2800pci, my rt3090 works with rt2860.bin, which is already in linux-firmware.

Larry
