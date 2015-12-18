Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54386 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbbLSAlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 19:41:14 -0500
Date: Fri, 18 Dec 2015 14:32:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Glen Lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	tony.cho@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: remove define COMPLEMENT_BOOT
Message-ID: <20151218223204.GA9349@kroah.com> (sfid-20151219_014117_708044_956A8556)
References: <1447898761-6938-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1447898761-6938-1-git-send-email-glen.lee@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 19, 2015 at 11:05:58AM +0900, Glen Lee wrote:
> This patch removes define COMPLEMENT_BOOT in Makefile. The feature was removed
> by the following commit but the define was not removed. So remove completely.
> 
> b46d68825c2d3af70ad18b53dfed6516e393b7fa

Please fix this up and resend the whole series.

thanks,

greg k-h
