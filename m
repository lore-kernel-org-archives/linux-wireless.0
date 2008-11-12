Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:27769 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbYKLWqx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 17:46:53 -0500
Subject: Re: ath5k master (AP) mode
From: Pavel Roskin <proski@gnu.org>
To: RUMI Szabolcs <rumi_ml@rtfm.hu>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081112224810.8d4ca179.rumi_ml@rtfm.hu>
References: <20081112224810.8d4ca179.rumi_ml@rtfm.hu>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 17:46:50 -0500
Message-Id: <1226530010.15173.0.camel@dv> (sfid-20081112_234656_893128_640E9061)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-12 at 22:48 +0100, RUMI Szabolcs wrote:
> Hello!
> 
> I've been trying to set an Atheros NIC to AP mode using the ath5k
> driver but it fails:
> 
> # iwconfig wlan0 mode master
> Error for wireless request "Set Mode" (8B06) :
>     SET failed on device wlan0 ; Invalid argument.

You need to use hostapd for master mode.

-- 
Regards,
Pavel Roskin
