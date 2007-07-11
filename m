Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4315 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758452AbXGKQGC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 12:06:02 -0400
Date: Wed, 11 Jul 2007 11:31:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, stable@kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [stable] [PATCH] softmac: Fix ESSID problem
Message-ID: <20070711153111.GC9404@tuxdriver.com>
References: <4692e2e0.u/1KuH/5hSPtXvF9%Larry.Finger@lwfinger.net> <20070711071418.GS4306@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070711071418.GS4306@sequoia.sous-sol.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 11, 2007 at 12:14:18AM -0700, Chris Wright wrote:
> * Larry Finger (Larry.Finger@lwfinger.net) wrote:
> > From: Jean Tourrilhes <jt@hpl.hp.com>
> > 
> > Victor Porton reported that the SoftMAC layer had random problem when setting the ESSID :
> > http://bugzilla.kernel.org/show_bug.cgi?id=8686 After investigation, it turned out to be
> > worse, the SoftMAC layer is left in an inconsistent state. The fix is pretty trivial.
> > 
> > Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
> > Acked-by: Michael Buesch <mb@bu3sch.df>
> > Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Please resend when this is accepted upstream.

FWIW, I passed it up to Jeff yesterday.

John
-- 
John W. Linville
linville@tuxdriver.com
