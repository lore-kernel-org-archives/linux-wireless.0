Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from galiil.marvell.com ([199.203.130.254]:18211 "EHLO
	galiil.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbZI2Si6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 14:38:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: Dan Williams <dcbw@redhat.com>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Tue, 29 Sep 2009 11:36:01 -0700
Subject: RE: [PATCH] libertas: Add auto deep sleep support for
 SD8385/SD8686/SD8688
Message-ID: <477F20668A386D41ADCC57781B1F704306DDC45F51@SC-VEXCH1.marvell.com>
References: <1253058359-1934-1-git-send-email-bzhao@marvell.com>
 <1253458691.11702.46.camel@localhost.localdomain>
 <477F20668A386D41ADCC57781B1F704306DDA6C1B6@SC-VEXCH1.marvell.com>,<200909290904.00971.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909290904.00971.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Holger,

> From: Holger Schurig [hs4233@mail.mn-solutions.de]
> Sent: Tuesday, September 29, 2009 12:04 AM
> To: Bing Zhao
> Cc: Dan Williams; libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org; Amitkumar Karwar
> Subject: Re: [PATCH] libertas: Add auto deep sleep support for SD8385/SD8686/SD8688
>
> Hi Bing !
> 
> Please note that I just sent an experimental patch to enable
> cfg80211 for libertas.
> 
> Once this is polished, you can immediately start using
> nl80211/cfg80211 to configure such things, there's no need to
> have the full thingy (e.g. wpa_supplicant via -Dnl80211 working
> with WEP/WPA/WPA2) working, those things are not interrelated.

Thanks for the info.

I will start to use nl80211/cfg80211 to configure my parameters as soon as your patch is in libertas driver.

Best regards,

Bing

>
>
> --
> http://www.holgerschurig.de