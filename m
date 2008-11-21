Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:38193 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYKUTuF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 14:50:05 -0500
Received: by ey-out-2122.google.com with SMTP id 6so457310eyi.37
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 11:50:03 -0800 (PST)
Message-ID: <492710E6.7020506@gmail.com> (sfid-20081121_205010_462617_679AD8D6)
Date: Fri, 21 Nov 2008 21:49:58 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: set mac address in add_interface
References: <20081118044037.GA18983@hash.localnet>
In-Reply-To: <20081118044037.GA18983@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> Hi Maxim, 
> 
> Please try this patch.  I didn't have a problem changing the mac address 
> after it was set to something else.  I did kick it to re-associate with
> the AP, though.
> 

Tested it, this still doesn't work:

iwconfig wlan0 down
macchanger wlan0
iwconfig wlan0 up

......
at that point card doesn't associate.

if I now set mac back to original, it works.


setting the mac before first ifconfig up (or networkmanager)
works.


I did some more testing on wireless transfer speeds, I post a separate
message about that, very soon.


Best regards,
	Maxim Levitsky

