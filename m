Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:16230 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbaIIKfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 06:35:54 -0400
Message-ID: <540ED808.7030606@broadcom.com> (sfid-20140909_123600_217858_88B1895A)
Date: Tue, 9 Sep 2014 12:35:52 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Bastien Nocera <hadess@hadess.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Realtek GPIO chipset, for Baytrail?
References: <1410256608.4077.7.camel@hadess.net>
In-Reply-To: <1410256608.4077.7.camel@hadess.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/14 11:56, Bastien Nocera wrote:
> Hey,
>
> I have a tablet that seems to be using Realtek chips to do wireless
> communications (hopefully, this time I won't be wrong[1]).
>
> The device, under the gpio class in /sys, shows with a modalias of
> "acpi:OBDA8723:" (that's on "O", not "0"). This seems to correspond to a
> Realtek chipset (Larry tells me it matches the PCI ID of 0bda:8723 for
> the RTL8723AE chipset).
>
> It shows up under:
> /sys/devices/platform/80860F0A:00/subsystem/devices
>
> Does anyone have details on how this chipset is actually hooked up? Can
> a portion of the existing RTL8723AE driver code be reused?

It is unlike that it is hooked up with GPIO. It could be using a GPIO 
for some purpose like host wakeup during sleep.

Regards,
Arend

> Cheers
>
> [1]:
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/127591/focus=127703
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

