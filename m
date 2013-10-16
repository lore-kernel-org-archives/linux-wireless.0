Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36951 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760844Ab3JPTqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 15:46:39 -0400
Date: Wed, 16 Oct 2013 12:46:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: vt6656: rxtx change u32 [4] aWTxKey to
 u8[16] tx_key
Message-ID: <20131016194638.GA25749@kroah.com> (sfid-20131016_214643_023175_F40AD983)
References: <1381870009.5100.45.camel@canaries32-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381870009.5100.45.camel@canaries32-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 15, 2013 at 09:46:49PM +0100, Malcolm Priestley wrote:
> Replace 4 x u32 aWTxKey with u8 array of 16 bytes tx_key.
> 
> Replaces pbyBuf in s_vFillTxKey and connects pbyTxBufferAddr
> directly to tx_key without a cast elsewhere in structure.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>

This patch causes a bunch of compiler warnings to get spit out by the
compiler, so I can't take it.

Please fix them up and resend.

thanks,

greg k-h
