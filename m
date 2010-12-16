Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40808 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513Ab0LPPaG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 10:30:06 -0500
Date: Thu, 16 Dec 2010 10:21:21 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: convert to __packed notation
Message-ID: <20101216152121.GB2413@tuxdriver.com>
References: <1292510088-7449-1-git-send-email-linville@tuxdriver.com>
 <4D0A2AA8.5060808@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D0A2AA8.5060808@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 16, 2010 at 09:05:12AM -0600, Larry Finger wrote:
> On 12/16/2010 08:34 AM, John W. Linville wrote:
> > Use "__packed" instead of "__attribute__ ((packed))"...
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
 
> ACK.
> 
> As a point of interest, is this the "new" recommended way? The reason I ask is
> that the Linux headers are mostly in the attribute form.

AIUI, "__packed" is the one true way.  I think this facilitates
compling the kernel with compilers other than GCC.

At any rate, Dave Miller threatened to injure me if I kept sending him stuff using 
"__attribute__ ((packed))"... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
