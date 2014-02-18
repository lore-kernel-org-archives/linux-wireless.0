Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbaBRS7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Feb 2014 13:59:21 -0500
Date: Tue, 18 Feb 2014 11:00:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/5] staging: vt6656: Remove variable
 fKillEventPollingThread
Message-ID: <20140218190046.GA20757@kroah.com> (sfid-20140218_195935_082764_0E938BDE)
References: <1392672273.11154.13.camel@canaries64-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392672273.11154.13.camel@canaries64-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 17, 2014 at 09:24:33PM +0000, Malcolm Priestley wrote:
> We already kill the urb and since patch
> s_nsInterruptUsbIoCompleteRead add urb status returns.
> have error handling
> 
> There is no need for this variable.
> 
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> 
> Conflicts:
> 	drivers/staging/vt6656/usbpipe.c

Why is this in your Changelog entry?

