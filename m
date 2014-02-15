Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbaBOUcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Feb 2014 15:32:35 -0500
Date: Sat, 15 Feb 2014 12:33:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: vt6656: Replace typedef enum _CARD_OP_MODE
Message-ID: <20140215203356.GA27625@kroah.com> (sfid-20140215_213239_616879_EFD9C1D7)
References: <1392488920.2518.17.camel@canaries64-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392488920.2518.17.camel@canaries64-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 15, 2014 at 06:28:40PM +0000, Malcolm Priestley wrote:
> Replace typedef enum _CARD_OP_MODE eOPMode with op_mode enum nl80211_iftype
> 
> enum changes
> OP_MODE_INFRASTRUCTURE -> NL80211_IFTYPE_STATION
> OP_MODE_AP -> NL80211_IFTYPE_AP
> OP_MODE_DEF -> NL80211_IFTYPE_UNSPECIFIED
> OP_MODE_ADHOC -> NL80211_IFTYPE_ADHOC
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

This fails to apply to my staging-next branch:
checking file drivers/staging/vt6656/card.h
checking file drivers/staging/vt6656/device.h
checking file drivers/staging/vt6656/dpc.c
checking file drivers/staging/vt6656/int.c
checking file drivers/staging/vt6656/iwctl.c
checking file drivers/staging/vt6656/main_usb.c
checking file drivers/staging/vt6656/power.c
checking file drivers/staging/vt6656/rxtx.c
Hunk #2 FAILED at 992.
1 out of 8 hunks FAILED
checking file drivers/staging/vt6656/wmgr.c

Care to resync and resend this series?

thanks,

greg k-h
