Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57142 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbbJHKNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 06:13:18 -0400
Date: Thu, 8 Oct 2015 11:03:42 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 01/11] staging: wilc1000: replace drvHandler and hWFIDrv
 with hif_drv
Message-ID: <20151008100342.GA22739@kroah.com> (sfid-20151008_121320_623011_BB199D57)
References: <1444295456-25818-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444295456-25818-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 08, 2015 at 06:10:46PM +0900, Tony Cho wrote:
> This patch replaces the variable names of struct host_if_drv used as the
> functions' input parameter, drvHandler and hWFIDrv with hif_drv. In
> addition, the local variable declared in many functions, pstrWFIDrv is
> removed and hif_drv is directly used. A debug message printing pstrWFIDrv is
> deleted while removing the local variable because it is not useful as well.
> 
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 1264 +++++++++++++----------------
>  1 file changed, 573 insertions(+), 691 deletions(-)

And of course, this one didn't apply either :(
