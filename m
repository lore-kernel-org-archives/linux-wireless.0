Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35112 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbbKNGwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2015 01:52:37 -0500
Received: by pacej9 with SMTP id ej9so14972827pac.2
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2015 22:52:37 -0800 (PST)
Date: Sat, 14 Nov 2015 12:22:29 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Panayiotis Tembriotis <panayiotis.tembriotis@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: remove new line around else and braces
Message-ID: <20151114065229.GC3685@sudip-pc> (sfid-20151114_075304_765702_7EA4F182)
References: <1447451987-5447-1-git-send-email-panayiotis.tembriotis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447451987-5447-1-git-send-email-panayiotis.tembriotis@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 13, 2015 at 11:59:47PM +0200, Panayiotis Tembriotis wrote:
> Remove excess new line characters as suggested by checkpatch.pl:
> ERROR: else should follow close brace '}'
> ERROR: that open brace { should be on the previous line
> 
> Signed-off-by: Panayiotis Tembriotis <panayiotis.tembriotis@gmail.com>
> ---

This has already been done. please use staging-testing tree.

regards
sudip
