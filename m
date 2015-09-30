Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18482 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbbI3LAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 07:00:35 -0400
Date: Wed, 30 Sep 2015 14:00:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 29/32] staging: wilc1000: rename strHostIfRegisterFrame
Message-ID: <20150930105857.GF7340@mwanda> (sfid-20150930_130038_286379_594F2C5A)
References: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
 <1443606914-25563-7-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443606914-25563-7-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 30, 2015 at 06:55:11PM +0900, Tony Cho wrote:
> This patch renames strHostIfRegisterFrame to reg_f to avoid CamelCase
> naming convention.

Could we go with "reg_frame"?  f is very ambigous.

regards,
dan carpenter

