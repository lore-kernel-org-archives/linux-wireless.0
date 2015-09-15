Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:35780 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbbIOFNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 01:13:53 -0400
Date: Tue, 15 Sep 2015 10:43:45 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: gregkh@linuxfoundation.org, rachel.kim@atmel.com,
	dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: stating: wilc1000: Add a check for SPI
 availability
Message-ID: <20150915051345.GC12611@sudip-pc> (sfid-20150915_071412_249095_E20CCD00)
References: <1442249474-3014-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442249474-3014-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 14, 2015 at 10:21:14PM +0530, Chandra S Gorentla wrote:
> NULL pointer deference is observed in the wilc1000.ko module
> with bus type SPI and when SPI is not ready.
> 
> Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
> ---
A small spelling mistake in the subject. It should be "staging" and not
"stating"

regards
sudip
