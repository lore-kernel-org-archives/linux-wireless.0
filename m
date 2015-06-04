Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45633 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbFDKjD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 06:39:03 -0400
Date: Thu, 4 Jun 2015 11:38:56 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Scott Branden <sbranden@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stable <stable@vger.kernel.org>, Andrew Kurn <kurn@sfu.ca>
Subject: Re: New USB ID 2001:3c25
Message-ID: <20150604103856.GB1733@ares> (sfid-20150604_123907_685284_4849B2E5)
References: <556E6000.90402@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <556E6000.90402@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2015 at 09:01:36PM -0500, Larry Finger wrote:
> Scott,
> 
> I see that you added the USB ID in the subject for the DWA-130 device in
> commit ea345c145ff23197eab34d0c4d0c8a93d7bea8c6.
> 
> Is there any reason that the new ID should not have been sent to Stable as
> well, or was that an oversight?
> 

Thanks Larry, I'll queue this patch for the 3.16 kernel.

Cheers,
--
Luís
