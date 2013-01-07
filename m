Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:59966 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab3AGTPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 14:15:00 -0500
Received: by mail-pb0-f44.google.com with SMTP id uo1so10761835pbc.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 11:15:00 -0800 (PST)
Date: Mon, 7 Jan 2013 11:14:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/11] staging: vt6656: create new structure names to
 remove typedefs.
Message-ID: <20130107191456.GA8395@kroah.com> (sfid-20130107_201506_404292_A8343DE9)
References: <1355176559.4680.15.camel@canaries64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1355176559.4680.15.camel@canaries64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 10, 2012 at 09:55:59PM +0000, Malcolm Priestley wrote:
> 
> This patch and the next 8 patches remove the old structure names and
> replace;
> 
> 
> struct vnt_private for DEVICE_INFO and PSDevice
> struct vnt_manager for SMgmtObject
> struct vnt_rx_mgmt for SRxMgmtPacket and PSRxMgmtPacket
> struct vnt_tx_mgmt for STxMgmtPacket and PSTxMgmtPacket
> 
> and
> 
> struct vnt_manager vnt_mgmt
> to replace
> SMgmtObject sMgmtObj;
> 
> Applied after patch staging: vt6656: dpc.c :RXbBulkInProcessData clean up RSC

Not all of these patches could be applied, can you please redo the ones
I didn't apply and resend them?

thanks,

greg k-h
