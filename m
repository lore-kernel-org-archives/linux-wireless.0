Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:33325 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304Ab3EOAMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 May 2013 20:12:19 -0400
Received: by mail-we0-f181.google.com with SMTP id q55so1042169wes.26
        for <linux-wireless@vger.kernel.org>; Tue, 14 May 2013 17:12:18 -0700 (PDT)
Message-ID: <1368576733.2741.1.camel@canaries64> (sfid-20130515_021222_841754_82B3BE12)
Subject: Re: [PATCH] staging: vt6656: [bug] Fix missing spin lock in
 iwctl_siwpower.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Andres More <more.andres@gmail.com>, linux-wireless@vger.kernel.org
Date: Wed, 15 May 2013 01:12:13 +0100
In-Reply-To: <1368574484.5342.5.camel@canaries64>
References: <1368574484.5342.5.camel@canaries64>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-15 at 00:34 +0100, Malcolm Priestley wrote:
> Fixes occasional dead lock on power up / down.
> 
> Only relevant to kernels 3.8 and later when command was
> transferred to the iw_handler.
> 

Please ignore this patch, I will redo, I shouldn't have used
spin_lock_irqsave.

Malcolm

