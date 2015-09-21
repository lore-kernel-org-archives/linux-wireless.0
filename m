Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbbIUFy0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 01:54:26 -0400
Date: Sun, 20 Sep 2015 22:54:25 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tony Cho <tony.cho@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, rachel.kim@atmel.com,
	glen.lee@atmel.com, leo.kim@atmel.com, austin.shin@atmel.com,
	adel.noureldin@atmel.com, adham.abozaeid@atmel.com,
	Nicolas.FERRE@atmel.com
Subject: Re: [PATCH v2 02/34] staging: wilc1000: remove typedef from the
 struct
Message-ID: <20150921055425.GA2514@kroah.com> (sfid-20150921_075429_513941_F1AD7415)
References: <1442805423-3711-1-git-send-email-tony.cho@atmel.com>
 <1442805423-3711-3-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442805423-3711-3-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 21, 2015 at 12:16:31PM +0900, Tony Cho wrote:
> The Linux kernel coding style does not recommend to use typedef for the
> structure. This patch removes typedef from the host_if_msg structure.
> 
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This too is already in my tree, you don't have to resend it.
