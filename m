Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:37179 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbXGKHO3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 03:14:29 -0400
Date: Wed, 11 Jul 2007 00:14:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [stable] [PATCH] softmac: Fix ESSID problem
Message-ID: <20070711071418.GS4306@sequoia.sous-sol.org>
References: <4692e2e0.u/1KuH/5hSPtXvF9%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4692e2e0.u/1KuH/5hSPtXvF9%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Larry Finger (Larry.Finger@lwfinger.net) wrote:
> From: Jean Tourrilhes <jt@hpl.hp.com>
> 
> Victor Porton reported that the SoftMAC layer had random problem when setting the ESSID :
> http://bugzilla.kernel.org/show_bug.cgi?id=8686 After investigation, it turned out to be
> worse, the SoftMAC layer is left in an inconsistent state. The fix is pretty trivial.
> 
> Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
> Acked-by: Michael Buesch <mb@bu3sch.df>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Please resend when this is accepted upstream.

thanks,
-chris
