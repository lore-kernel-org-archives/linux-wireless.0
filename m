Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcBCXah (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:30:37 -0500
Date: Wed, 3 Feb 2016 15:30:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Leo Kim <leo.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, Chris.Park@atmel.com,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, tony.cho@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 05/12] staging: wilc1000: wilc_parse_network_info():
 renames function variables
Message-ID: <20160203233036.GA13676@kroah.com> (sfid-20160204_003041_984850_7B479BAD)
References: <1453965226-6158-1-git-send-email-leo.kim@atmel.com>
 <1453965226-6158-5-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453965226-6158-5-git-send-email-leo.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 28, 2016 at 04:13:39PM +0900, Leo Kim wrote:
> This patch renames to avoid camelcase, changes follow are:
>  - pu8MsgBuffer to msg_buffer
>  - ppstrNetworkInfo to ret_network_info
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.c | 16 ++++++++--------
>  drivers/staging/wilc1000/coreconfigurator.h |  2 +-
>  2 files changed, 9 insertions(+), 9 deletions(-)

This patch failed to apply, so please refresh it and the rest of this
series against my staging-testing branch and resend it.

thanks,

greg k-h
