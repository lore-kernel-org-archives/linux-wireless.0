Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab3HLWAA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 18:00:00 -0400
Date: Mon, 12 Aug 2013 14:59:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: vt6656: rxtx.h always pack
 BEACON_BUFFER/TX_BUFFER
Message-ID: <20130812215959.GA1473@kroah.com> (sfid-20130813_000005_249911_2A9E8C39)
References: <1375733094.7004.23.camel@canaries64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375733094.7004.23.camel@canaries64>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 05, 2013 at 09:04:54PM +0100, Malcolm Priestley wrote:
> All structure members of BEACON_BUFFER/TX_BUFFER should be packed.

Why?

What happens if they are not?

greg k-h
