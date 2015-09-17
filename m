Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33672 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbbIQKef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 06:34:35 -0400
Received: by pacex6 with SMTP id ex6so17274136pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2015 03:34:34 -0700 (PDT)
Date: Thu, 17 Sep 2015 16:04:26 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH V2 3/8] staging: wilc1000: replace int8_t with int
Message-ID: <20150917103426.GB20514@sudip-pc> (sfid-20150917_123442_284109_686C0F13)
References: <1442476129-14908-1-git-send-email-chaehyun.lim@gmail.com>
 <1442476129-14908-3-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442476129-14908-3-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 17, 2015 at 04:48:44PM +0900, Chaehyun Lim wrote:
> This patch replaces int8_t with int. just use return type as int.
> 
> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
> ---
but isn't int8_t is defined as char?

regards
sudip
