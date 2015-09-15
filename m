Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33622 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbbIOHNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 03:13:45 -0400
Received: by pacex6 with SMTP id ex6so168650449pac.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2015 00:13:45 -0700 (PDT)
Date: Tue, 15 Sep 2015 12:43:37 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: remove unused variable
 g_num_total_switches
Message-ID: <20150915071337.GH12611@sudip-pc> (sfid-20150915_091349_367440_349D518F)
References: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442295237-12644-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2015 at 02:33:54PM +0900, Tony Cho wrote:
> From: Glen Lee <glen.lee@atmel.com>
> 
> g_num_total_switches is never used so just delete it.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
you only deleted from the .h file but it still remains in
coreconfigurator.c

regards
sudip
