Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.natecarlson.com ([74.117.236.15]:56510 "EHLO
	plesk.technicality.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751676AbaD2OCA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 10:02:00 -0400
Received: from admin-chi.chi.technicality.org (unknown [IPv6:2607:ff50:1::1:3])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by plesk.technicality.org (Postfix) with ESMTPSA id 445D11814531B
	for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2014 08:55:48 -0500 (CDT)
Date: Tue, 29 Apr 2014 08:55:47 -0500 (CDT)
From: Nate Carlson <linux-wireless@natecarlson.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ANN] New firmware for Intel 7260 / 3160 - 22.212.9.0
In-Reply-To: <CANUX_P1GBeBdPkci6c9cDyz4C4uxA6ktaGvwgPQTDzEPsuEPgg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1404290849580.28094@admin.chi.technicality.org> (sfid-20140429_160205_277916_6D1AEF96)
References: <CANUX_P1GBeBdPkci6c9cDyz4C4uxA6ktaGvwgPQTDzEPsuEPgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 28 Apr 2014, Emmanuel Grumbach wrote:
> we have released a new firmware for 7260, 3160 and 7265 Intel WiFi 
> devices. This firmware is supported starting 3.14 kernel (when [2] will 
> hit it). We have a here quite a few bug fixes with a few new features 
> advertised by flags in the firmware file. The most visible bug fix is a 
> ping loss issue we had with certain APs when using uAPSD.

Excellent! I've actually been watching almost-daily for a new firmware 
version, hoping it'd help out some of the issues I've been having with a 
7260 on a Cisco 802.11ac network. Primary issue is that my laptop would 
suddenly pick an AP with a very weak signal, and my connection would end 
up breaking to the point of being unusable until I reconnected (I think 
this is actually wpa_supplicant's job, not the card/driver/firmware, but 
since it worked fine on an old 6300 card on 802.11n I figure there has to 
be something with this card causing issues.) With a combination modern 
kernel (3.14.1+ or the 3.15 tree) and the previous firmware release, 
things were better, but I'd still have to reconnect maybe once or twice a 
day - and it never picked the 'best' AP (ie - my signal would always be 
relatively weak, even though there is an AP about 30 feet away from my 
desk). Installed this firmware with a build of 3.15, rebooted, and I've 
got a nice strong signal right off the bat:

signal:  	-55 [-55] dBm
signal avg:	-54 [-54] dBm
tx bitrate:	780.0 MBit/s VHT-MCS 8 80MHz short GI VHT-NSS 2
rx bitrate:	702.0 MBit/s VHT-MCS 8 80MHz VHT-NSS 2

It'll be interesting to see if it keeps on helping.  ;)

Thanks!

-Nate
