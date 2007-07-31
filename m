Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:43677 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbXGaNtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 09:49:23 -0400
Message-ID: <46AF3DDF.8050609@warmcat.com>
Date: Tue, 31 Jul 2007 14:49:19 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Ivo van Doorn <ivdoorn@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt73usb-add-bluenext-148f-2573
References: <20070731115446.5717.37617.stgit@localhost> <200707311427.58948.IvDoorn@gmail.com> <46AF2D5C.6090803@warmcat.com> <200707311458.40936.IvDoorn@gmail.com>
In-Reply-To: <200707311458.40936.IvDoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> echo 16 > csr_offset
> cat csr_value
> 
> This will read the TXRX_CSR0 register of rt73usb which controls the filtering
> of the frames. That will help determining if the missing frames have been
> droppen in the hardware or not.

after the echo, catting that spews

0x007eb162

repeatedly to the console.

-Andy
