Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:49963 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422749AbXDRJtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 05:49:09 -0400
From: Chr <chunkeey@web.de>
To: Stefan Puch <stefan.puch@mail.uni-oldenburg.de>
Subject: Re: prism54: WPA/RSN support for fullmac cards
Date: Wed, 18 Apr 2007 11:49:06 +0200
References: <462336B1.4090006@mail.uni-oldenburg.de> <200704172123.30956.chunkeey@web.de> <4625DE1E.1040302@mail.uni-oldenburg.de>
In-Reply-To: <4625DE1E.1040302@mail.uni-oldenburg.de>
Cc: linux-net@vger.kernel.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704181149.06856.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, 18. April 2007 11:00, you wrote:

> 
> Conclusion:
> It seems that Softmac firmware version greater than 2.13.x.x have WPA2 + AES
> Support, perhaps this helps for further development or reverse engineering of
> the firmware.
> (I could although provide debug traces from wpa_supplicant when using WPA2 + AES
> with ndiswrapper if that helps)
> 
No, that's why they are called "Softmac" FW. Now the whole encryption 
(WEP/WPA/RSN with RC4, TKIP and CCMP) is done in software by your 
host CPU and not by the card... 

But please stick with the 2.7.0.0 FW, the all drivers are written for/from ;) it.

Oh, and if you're interested in the FW, you should take a look @ the freemac project. 
AFAIK, it doesn't work yet, but it contains some "helpful" hints about these devices.

