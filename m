Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbbFQCSx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 22:18:53 -0400
Date: Tue, 16 Jun 2015 19:18:52 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Abdul, Hussain (H.)" <habdul@visteon.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Dighe, Niranjan (N.)" <ndighe@visteon.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"Ravindran, Madhusudhanan (M.)" <mravindr@visteon.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>
Subject: Re: [PATCH] Staging: wilc1000: Remove casting the values returned by
 kmalloc()
Message-ID: <20150617021852.GB18383@kroah.com> (sfid-20150617_041913_195257_E4B5D1B3)
References: <1434438549-5340-1-git-send-email-habdul@visteon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434438549-5340-1-git-send-email-habdul@visteon.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2015 at 07:10:28AM +0000, Abdul, Hussain (H.) wrote:
> From: Abdul Hussain <habdul@visteon.com>
> 
> This patch removes casting the values returned by memory allocation functions.
> 
> Signed-off-by: Abdul Hussain <habdul@visteon.com>
> ---
>  drivers/staging/wilc1000/linux_wlan.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Does not apply :(
