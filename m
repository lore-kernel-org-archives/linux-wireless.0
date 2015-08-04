Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48077 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbbHDAhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Aug 2015 20:37:33 -0400
Date: Mon, 3 Aug 2015 17:37:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] drivers: staging: wilc1000: use 'void' for no
 arguments functions
Message-ID: <20150804003732.GA5311@kroah.com> (sfid-20150804_023750_484188_CB961EDC)
References: <1438530833-24640-1-git-send-email-csgorentla@gmail.com>
 <1438530833-24640-2-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1438530833-24640-2-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 02, 2015 at 09:23:51PM +0530, Chandra S Gorentla wrote:
> Added 'void' keyword in the paranthesis of function definitions, when
> there are no arguments to the functions.  This fixes the checkpatch.pl
> error - "Bad function definition 'function()' should probably be
> function(void)".
> 
> Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>

This series does not apply cleanly.  Please rebased on the latest
staging-testing branch of the staging.git tree and resend.

thanks,

greg k-h
