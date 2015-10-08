Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbbJHKNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 06:13:07 -0400
Date: Thu, 8 Oct 2015 11:03:17 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 01/14] staging: wilc1000: remove typedef from
 tstrWILC_UsrScanReq
Message-ID: <20151008100317.GA22641@kroah.com> (sfid-20151008_121310_770190_AFFBF2FE)
References: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444268961-7551-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 08, 2015 at 10:49:08AM +0900, Tony Cho wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch removes typedef from the struct tstrWILC_UsrScanReq with
> related comments and renames it to user_scan_req.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.h | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

This series also didn't apply :(
