Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932179AbaGWXMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 19:12:01 -0400
Date: Wed, 23 Jul 2014 16:12:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: vt6655: Fix Warning on boot
 handle_irq_event_percpu.
Message-ID: <20140723231200.GB31075@kroah.com> (sfid-20140724_011208_155608_77860D24)
References: <1406147712-3152-1-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1406147712-3152-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2014 at 09:35:11PM +0100, Malcolm Priestley wrote:
> WARNING: CPU: 0 PID: 929 at /home/apw/COD/linux/kernel/irq/handle.c:147 handle_irq_event_percpu+0x1d1/0x1e0()
> irq 17 handler device_intr+0x0/0xa80 [vt6655_stage] enabled interrupts
> 
> Using spin_lock_irqsave appears to fix this.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> Cc: <stable@vger.kernel.org>

So should both of these go into the 3.16-final kernel release?

thanks,

greg k-h
