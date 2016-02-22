Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45523 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbcBVUBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 15:01:51 -0500
Date: Mon, 22 Feb 2016 12:01:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Leo Kim <leo.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, Chris.Park@atmel.com,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH V4 00/24] staging: wilc1000: Resend V4
Message-ID: <20160222200150.GA23581@kroah.com> (sfid-20160222_210154_452108_94BB1ABF)
References: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456136071-10502-1-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 22, 2016 at 07:14:07PM +0900, Leo Kim wrote:
> Dear Greg
> 
> This is the 4th fix patch about the mistake merging.
> Mistake merging is revert the below commit when rebase V3 patches.
> (already applied commit) - 6c2ab2398b88 ("staging: wilc1000: remove spaces around '->'")
> (V3 mistake patch) - [PATCH V3 09/24] staging: wilc1000: wilc_wfi_cfgoperations.c: removes unnecessary log messages
> 
> I'll resend 4th patches after modified this mistake.
> We apologize for the inconvenience.

Oops, I applied the v3 series, can you just send me a "fixup patch" or
whatever else is needed here instead?

thanks,

greg k-h
