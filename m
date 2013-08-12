Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3HLW1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 18:27:32 -0400
Date: Mon, 12 Aug 2013 15:27:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] staging: vt6656: rxtx.c s:_uGetDataDuration simplify
 structure
Message-ID: <20130812222731.GA14479@kroah.com> (sfid-20130813_002735_170327_A54AAD98)
References: <1375907588.5626.40.camel@canaries64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375907588.5626.40.camel@canaries64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 07, 2013 at 09:33:08PM +0100, Malcolm Priestley wrote:
> A value is only returned when bNeedAck is true.
> 
> Only when byDurType == DATADUR_B is different.
> 
> Remove switch statement and simplify with if structure.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

This one didn't apply due to other patches I didn't apply in your
previous ones.

Can you redo all of these and resend them against my staging-next tree
so that I can apply them?

thanks,

greg k-h
