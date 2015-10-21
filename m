Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33487 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbbJULrM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 07:47:12 -0400
Date: Wed, 21 Oct 2015 14:47:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	austin.shin@atmel.com, linux-wireless@vger.kernel.org,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH] staging: wilc1000: fix the bug on copying bssid
Message-ID: <20151021114703.GH7340@mwanda> (sfid-20151021_134725_413659_101CF2D7)
References: <1445328646-32178-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445328646-32178-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 20, 2015 at 05:10:46PM +0900, Tony Cho wrote:
> This patch reverts the commit, d79fd35b8c5d927695b48fa35aa586919818cce9.
> 
> The WID_JOIN_REQ_EXTENDED among WIDs needs two parameters for the request to
> be sent to the firmware, which are the SA and the BSSID. For this case, both
> is the same bssid in the handle_connect function. So, it's required to be
> copied twice.
> 

I forsaw this, but I should have been more explicit when I complained
about d79fd35b8c5d927695b48fa35aa586919818cce9...

regards,
dan carpenter

