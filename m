Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:51661 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759184AbaGXOzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 10:55:25 -0400
Message-ID: <53D11E51.2090709@gmail.com> (sfid-20140724_165529_975798_479C8E24)
Date: Thu, 24 Jul 2014 15:55:13 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: vt6655: Fix Warning on boot handle_irq_event_percpu.
References: <1406147712-3152-1-git-send-email-tvboxspy@gmail.com> <20140723231200.GB31075@kroah.com>
In-Reply-To: <20140723231200.GB31075@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 24/07/14 00:12, Greg KH wrote:
> On Wed, Jul 23, 2014 at 09:35:11PM +0100, Malcolm Priestley wrote:
>> WARNING: CPU: 0 PID: 929 at /home/apw/COD/linux/kernel/irq/handle.c:147 handle_irq_event_percpu+0x1d1/0x1e0()
>> irq 17 handler device_intr+0x0/0xa80 [vt6655_stage] enabled interrupts
>>
>> Using spin_lock_irqsave appears to fix this.
>>
>> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
>> Cc: <stable@vger.kernel.org>
>
> So should both of these go into the 3.16-final kernel release?

Yes, the driver is very unstable without these patches

Regards

Malcolm
