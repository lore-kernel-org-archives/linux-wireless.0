Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbbLSAo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:44:29 -0500
Date: Fri, 18 Dec 2015 14:43:43 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH 1/3] staging: wilc1000: move perInterface_wlan_t to
 wilc_vif
Message-ID: <20151218224343.GA9053@kroah.com> (sfid-20151219_014432_196256_949E4D67)
References: <1448607033-25354-1-git-send-email-glen.lee@atmel.com>
 <1448607033-25354-2-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1448607033-25354-2-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 27, 2015 at 03:50:31PM +0900, Glen Lee wrote:
> perInterface_wlan_t and wilc_vif are all about interface control informations.
> We will combine those two structures and maintain as one network interface
> control information.
> Move all the members of perInterface_wlan_t to wilc_vif and remove the
> structure. Rename perInterace_wlan_t to wilc_vif and rename variable name nic
> to vif which is proper name for it.
> 
> Signed-off-by: Glen Lee <glen.lee@atmel.com>

Series did not apply :(
