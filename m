Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2888 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab2FRPil (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 11:38:41 -0400
Date: Mon, 18 Jun 2012 08:37:42 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <me@bobcopeland.com>,
	<mickflemm@gmail.com>
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
Message-ID: <20120618153742.GB12526@tux> (sfid-20120618_173845_649694_5ADD2ED4)
References: <1339399952.4520.13.camel@jlt3.sipsolutions.net>
 <4FD60369.80108@qca.qualcomm.com>
 <1339425944.4520.27.camel@jlt3.sipsolutions.net>
 <20120614193104.GD32257@tux>
 <1339748211.4512.6.camel@jlt3.sipsolutions.net>
 <4FDAF096.200@qca.qualcomm.com>
 <4FDB1740.60707@broadcom.com>
 <4FDB5E52.1020608@qca.qualcomm.com>
 <CAB=NE6X=pO5c_yUqMmqU1jm92WJKqBbYioYm-2S4AYS2JXYRTA@mail.gmail.com>
 <4FDC7887.8090907@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FDC7887.8090907@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 16, 2012 at 02:13:59PM +0200, Arend van Spriel wrote:
> On 06/15/2012 06:53 PM, Luis R. Rodriguez wrote:
> > So how about CONFIG_CFG80211_CERTIFICATION_ONUS which can be defined
> > as an option for features / options whereby the onus for regulatory
> > certification is being accepted by the option enabler? Pretty simple
> > and to the point, and would allow for research code but also code
> > whereby a bit more work is required on the enabler like DFS
> > certification.
> 
> English is not my native language so I had to look up the meaning of the
> word 'onus'. I guess I am fine with it.

Great, I'll respin.

> Apart from the naming I addressed that if would be better to have it
> device on CONFIG_WLAN instead of CFG80211 as it will be used to enable
> 802.11 device driver features. Any thoughts on that?

OK so we have CONFIG_WLAN for devices and CONFIG_WIRELESS for the subsystem
which is enabled if anyone enables CONFIG_WLAN. The kconfig entry will not only
be used for 802.11 device drivers, it will also be used for some generic
subsystem options, I'll send patches for an idea there later after the first
slew go in.

  Luis
