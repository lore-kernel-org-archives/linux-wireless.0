Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37610 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbJAPkg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 11:40:36 -0400
Date: Thu, 1 Oct 2015 18:40:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chaehyun Lim <chaehyun.lim@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	devel@driverdev.osuosl.org, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 08/12] staging: wilc1000: use s8 instead of int8_t
Message-ID: <20151001154015.GJ7340@mwanda> (sfid-20151001_174040_266239_0D7692A9)
References: <1443707039-18433-1-git-send-email-chaehyun.lim@gmail.com>
 <1443707039-18433-8-git-send-email-chaehyun.lim@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443707039-18433-8-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 01, 2015 at 10:43:55PM +0900, Chaehyun Lim wrote:
> This patch replaces int8_t with s8 that is a preferred type.
> 

It would be better to just use int.

regards,
dan carpenter

