Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45368 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbcADLs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jan 2016 06:48:56 -0500
Date: Mon, 4 Jan 2016 14:48:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/3] rsi: Delete unnecessary variable initialisations in
 rsi_send_mgmt_pkt()
Message-ID: <20160104114849.GH5284@mwanda> (sfid-20160104_124919_947251_F0615F68)
References: <566ABCD9.1060404@users.sourceforge.net>
 <5687E169.4070704@users.sourceforge.net>
 <5687E203.1070404@users.sourceforge.net>
 <20160104092857.GD5284@mwanda>
 <568A4CFF.8060600@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <568A4CFF.8060600@users.sourceforge.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 04, 2016 at 11:44:15AM +0100, SF Markus Elfring wrote:
> > Please stop sending cleanup patches, Markus.  Just send fixes.
> 
> How often will source code clean-up fix something?
> 
> 
> May I resend a consistent patch series for the source file
> "drivers/net/wireless/rsi/rsi_91x_pkt.c" in the near future?

If you were sending checkpatch.pl fixes that would be easier to deal
with but you are sending hundreds of "controversial" cleanups.  They are
controversial in the sense that they don't fix anything against official
kernel style and they go against the author's original intention.  I
tend to agree that useless initializers are bad and disable GCCs
uninitialized variable warnings but just because I agree with you
doesn't make it official kernel style.  It's slightly rude to go against
the author's intention.

regards,
dan carpenter
