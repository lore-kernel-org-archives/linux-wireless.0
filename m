Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933031AbcBCXWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 18:22:52 -0500
Date: Wed, 3 Feb 2016 15:22:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/2] staging: wilc1000: move wilc_send_config_pkt to
 wilc_wlan.c
Message-ID: <20160203232251.GA31910@kroah.com> (sfid-20160204_002259_346006_05DBAA43)
References: <1453448170-26040-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1453448170-26040-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2016 at 04:36:09PM +0900, Glen Lee wrote:
> This patch moves the function wilc_send_config_pkt to wilc_wlan.c which
> handles transport since the purpose of the function is sending/getting of
> config information. coreconfiguator.[ch] will be rename with frame.[ch] later.
> The print codes of the function is removed also and they will be implemented
> with netdev_xx print format later.
> struct wid need to be moved to wilc_wlan_if.h which defines configure
> informations.

This series does not apply, please refresh against my staging-testing
branch and resend.

thanks,

greg k-h
