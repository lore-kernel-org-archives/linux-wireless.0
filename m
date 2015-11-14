Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34555 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbbKNHuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Nov 2015 02:50:44 -0500
Received: by wmvv187 with SMTP id v187so111344412wmv.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2015 23:50:43 -0800 (PST)
Date: Sat, 14 Nov 2015 09:50:39 +0200
From: Panayiotis Tembriotis <panayiotis.tembriotis@gmail.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH] staging: wilc1000: remove new line around else and braces
Message-ID: <20151114075039.GA588@maclinux> (sfid-20151114_085109_202764_99E64377)
References: <1447451987-5447-1-git-send-email-panayiotis.tembriotis@gmail.com>
 <20151114065229.GC3685@sudip-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151114065229.GC3685@sudip-pc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 14, 2015 at 12:22:29PM +0530, Sudip Mukherjee wrote:
> On Fri, Nov 13, 2015 at 11:59:47PM +0200, Panayiotis Tembriotis wrote:
> > Remove excess new line characters as suggested by checkpatch.pl:
> > ERROR: else should follow close brace '}'
> > ERROR: that open brace { should be on the previous line
> > 
> > Signed-off-by: Panayiotis Tembriotis <panayiotis.tembriotis@gmail.com>
> > ---
> 
> This has already been done. please use staging-testing tree.

Sorry for spamming and thanks for letting me know.

Regards,
Panayiotis
