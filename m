Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:40289 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761403AbYAYXJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 18:09:27 -0500
From: David Brownell <david-b@pacbell.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH 00/14][v3]: Driver for Wireless RNDIS USB devices.
Date: Fri, 25 Jan 2008 15:09:24 -0800
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	bjd@jooz.net
References: <20080125225032.11716.77713.stgit@fate.lan>
In-Reply-To: <20080125225032.11716.77713.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801251509.24377.david-b@pacbell.net> (sfid-20080125_230931_895463_00B746F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 January 2008, Jussi Kivilinna wrote:
> Hello,
> 
> Here is the third try on wireless RNDIS patchset.
> 
> Patches 1-9 are from second patchset (with name change rndis_wext -> rndis_wlan
> in comments where needed):
>  1. Fix sparse warning: returning void valued expression
>  2. [cdc_ether] Hardwire CDC descriptors when missing
>  3. [rndis_host] Use 1KB buffer in rndis_unbind
>  4. [rndis_host] Halt device if rndis_bind fails
>  5. [rndis_host] Fix rndis packet filter flags
>  6. [usbnet] Use wlan device name for RNDIS wireless devices
>  7. [rndis_host] Split up rndis_host.c
>  8. [rndis_host] export functions
>  9. [usbnet] add driver_priv pointer to 'struct usbnet'

If they're the same, my ack (as maintainer for that infrastructure
and, for now, rndis_host) still stands.  I won't look at them again.


> Changed patches 10-14:
> 10. [rndis_host] Add early_init function pointer to 'struct rndis_data'.
> 11. [rndis_host] Add link_change function pointer to 'struct rndis_data'.
> 12. [rndis_host] Add RNDIS physical medium checking into generic_rndis_bind()
> 13. Move usbnet.h and rndis_host.h to include/linux/usb
> 14. Add new driver 'rndis_wlan' for wireless RNDIS devices.
> 
