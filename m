Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:64181 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab3AHAAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 19:00:37 -0500
Received: by mail-wg0-f46.google.com with SMTP id dr13so10044182wgb.13
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 16:00:36 -0800 (PST)
Message-ID: <1357602787.12182.14.camel@canaries64> (sfid-20130108_010043_397099_4FD8FCBE)
Subject: Re: [PATCH 01/11] staging: vt6656: create new structure names to
 remove typedefs.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 07 Jan 2013 23:53:07 +0000
In-Reply-To: <20130107191456.GA8395@kroah.com>
References: <1355176559.4680.15.camel@canaries64>
	 <20130107191456.GA8395@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-07 at 11:14 -0800, Greg KH wrote:
> On Mon, Dec 10, 2012 at 09:55:59PM +0000, Malcolm Priestley wrote:
> > 
> > This patch and the next 8 patches remove the old structure names and
> > replace;
> > 
> > 
> > struct vnt_private for DEVICE_INFO and PSDevice
> > struct vnt_manager for SMgmtObject
> > struct vnt_rx_mgmt for SRxMgmtPacket and PSRxMgmtPacket
> > struct vnt_tx_mgmt for STxMgmtPacket and PSTxMgmtPacket
> > 
> > and
> > 
> > struct vnt_manager vnt_mgmt
> > to replace
> > SMgmtObject sMgmtObj;
> > 
> > Applied after patch staging: vt6656: dpc.c :RXbBulkInProcessData clean up RSC
> 
> Not all of these patches could be applied, can you please redo the ones
> I didn't apply and resend them?
> 
Yes, the missing rebased patches have been sent.

Regards


Malcolm

