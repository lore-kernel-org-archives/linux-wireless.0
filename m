Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4965 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1H3Jh0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:37:26 -0400
Message-ID: <4E5CAF48.6030205@broadcom.com> (sfid-20110830_113730_477967_9271F1CF)
Date: Tue, 30 Aug 2011 11:37:12 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hao Han" <hhanwm@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [DEV] modify 802.11 header on BCM4329
References: <CAGwCZhrVBr-Kit7h01z_1ME7xdz_yQ+BpV33+deGYA86QSS58g@mail.gmail.com>
In-Reply-To: <CAGwCZhrVBr-Kit7h01z_1ME7xdz_yQ+BpV33+deGYA86QSS58g@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2011 09:07 AM, Hao Han wrote:
> Hi all,
>
> I try to modify 802.11 header of tramsitted packets, especially
> management frames such as beacons. When the wireless interface works
> in master mode (enabled by new firmware named fw_bcm4329_apsta.bin), I
> do monitor beacons on air. However, I cannot find the place through
> the driver where these beacons are generated and transmitted. Is that
> in firmware?
>
> My goal is to modify the value of some exsiting field and add new
> fields in beacon. If anyone has such experience, please let me know.
> Any feedback would be extremely appreciated :)
>
> Best,
> Hao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Hao,

Your guess is right. bcm4329 has most of the stack functionality in 
firmware.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


