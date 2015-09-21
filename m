Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54244 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbbIUEid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 00:38:33 -0400
Date: Sun, 20 Sep 2015 19:06:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: rachel.kim@atmel.com, devel@driverdev.osuosl.org,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 08/18] staging: wilc1000: remove declaration of
 WILC_WFI_frame_register
Message-ID: <20150921020615.GA9549@kroah.com> (sfid-20150921_064009_724293_4223F48D)
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
 <1442731885-4344-8-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442731885-4344-8-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 20, 2015 at 03:51:15PM +0900, Chaehyun Lim wrote:
> This patch removes function declaration of WILC_WFI_frame_register in
> linux_wlan.c file, then adds it in wilc_wfi_cfgoperations.h file.
> 
> The compilation warning occurs because it is assigned to incorrect
> pointer type of second parameter of WILC_WFI_frame_register.
> It is assigned with struct wireless_dev pointer type.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>

I've skipped patches 08, 09, and 11 in this series, please rebase and
resend once Tony replies with what is really going on with this
function...

thanks,

greg k-h
