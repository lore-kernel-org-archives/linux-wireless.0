Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36837 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbbIOHRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 03:17:00 -0400
Received: by padhk3 with SMTP id hk3so168247152pad.3
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2015 00:16:59 -0700 (PDT)
Date: Tue, 15 Sep 2015 12:46:52 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 2/4] staging: wilc1000: delete function declaration
 SendRawPacket
Message-ID: <20150915071652.GI12611@sudip-pc> (sfid-20150915_091705_866793_1564E671)
References: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
 <1442295237-12644-2-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442295237-12644-2-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2015 at 02:33:55PM +0900, Tony Cho wrote:
> From: Glen Lee <glen.lee@atmel.com>
> 
> SendRawpacket is declared but not implemented. It is not used also.
> So just delete it.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
Still remains in coreconfigurator.c

regards
sudip
