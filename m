Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:51635 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbaLFUHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2014 15:07:12 -0500
Message-ID: <1417896444.5048.4.camel@posteo.de> (sfid-20141206_210828_765853_C0B4DD7D)
Subject: Re: [PATCH 7/7] brcmfmac: add multiple BSS support.
From: =?ISO-8859-1?Q?J=F6rg?= Krause <jkrause@posteo.de>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Date: Sat, 06 Dec 2014 21:07:24 +0100
In-Reply-To: <548356CF.3040001@broadcom.com>
References: <1417885078.22723.24.camel@posteo.de>
	 <54834833.50204@broadcom.com> <548356CF.3040001@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sa, 2014-12-06 at 20:19 +0100, Arend van Spriel wrote:
> 
> I realized that what you are trying to do here is adding a virtual AP 
> interface wlan0_ap and wlan0 is still configured as STA. This is not 
> possible with the current driver code. So actually it should not be 
> possible to create an AP interface when wlan0 is STA. At least for now.

At least it's possible to create an AP and still use the wlan0 interface
in station mode.

So the patch adds the possibility to use up to three different AP
interfaces. I will test this in the next days.



