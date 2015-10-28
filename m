Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35996 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbbJ1FYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 01:24:43 -0400
Received: by pacfv9 with SMTP id fv9so256195181pac.3
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2015 22:24:43 -0700 (PDT)
Date: Wed, 28 Oct 2015 10:53:56 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Glen Lee <glen.lee@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH V4] staging: wilc1000: wilc_msgqueue.c : remove goto
 statement
Message-ID: <20151028052356.GA10698@sudip-pc> (sfid-20151028_062446_521833_471A81F8)
References: <1445934817-27390-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445934817-27390-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 27, 2015 at 05:33:37PM +0900, Glen Lee wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch removes goto statement and moves the spin lock position.
> If a memory allocation fails, directly returns an error.
> The spin lock actually protects the pHandle. Therefore, call spin lock just
> before pHandle is used.
> 
> Signee-eff-by: Lee Kim <leo.kim@atmel.com>

Signed-off-by?

regards
sudip
