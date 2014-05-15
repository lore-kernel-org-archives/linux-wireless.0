Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaEOU2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 16:28:04 -0400
Date: Thu, 15 May 2014 13:31:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/13] staging: vt6656: lock changes: Remove spin locks
Message-ID: <20140515203122.GA13651@kroah.com> (sfid-20140515_222808_826677_FB4394AC)
References: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 03, 2014 at 03:17:22PM +0100, Malcolm Priestley wrote:
> Remove atomic paths to usbpipe.c PIPEnsControlOut and PIPEnsControlIn
> 
> Remove from
> PIPEnsControlOut
> PIPEnsControlIn
> BSSvSecondCallBack
> FIRMWAREbDownload
> vt6656_hostap_ioctl
> iwctl_siwmode
> iwctl_siwencode
> iwctl_siwpower
> iwctl_siwencodeext
> KeyvInitTable
> device_init_registers
> device_open
> device_close
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
> Note: All patches of these series must be applied.

Which makes this series fail :(

Can you please resend the patches from you that I haven't applied, after
refreshing them against my tree?

thanks,

greg k-h
