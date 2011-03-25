Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:24806 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab1CYRRf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 13:17:35 -0400
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 25 Mar 2011 13:17:34 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Wilson Loi <wlsloi@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Gao Yunpeng <yunpeng.gao@intel.com>
Subject: Re: [PATCH v1 2/2] sdio: add power_restore support with
 MMC_PM_KEEP_POWER mode
In-reply-to: <AANLkTi=Zh2mY8SDRR6431=ykGOLAZJfmgAoDp09aV+O_@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1103251315080.11889@xanadu.home>
References: <AANLkTi=CSK8nRF7CTzsq06Bk8Cr74ZcwJBf53_wWbpnv@mail.gmail.com>
 <AANLkTimvLzgO1VHAbYz0uh-TVBGdLr-aDcyaGyzS2QMi@mail.gmail.com>
 <AANLkTimevrNU+JC=KvMzpGfip7cimPMo2cmBzvPiMb9R@mail.gmail.com>
 <AANLkTi=Zh2mY8SDRR6431=ykGOLAZJfmgAoDp09aV+O_@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 26 Mar 2011, Wilson Loi wrote:

> Sorry, this is the first time I sent a patch.
> 
> There are two case for the WLAN SDIO card to do power saving.
> 1. Totally cut off the power of WLAN network interface.
> 2. offload the network state to WLAN SDIO firmware.

Case #2 is already supported with current code.  Patches for the 
libertas driver are in the OLPC repository (no idea if they were 
submitted upstream yet).


Nicolas
