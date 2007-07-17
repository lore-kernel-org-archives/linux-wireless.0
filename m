Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4737 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970AbXGQSCw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2007 14:02:52 -0400
Date: Tue, 17 Jul 2007 13:57:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: stable@kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] softmac: Fix ESSID problem
Message-ID: <20070717175756.GD9037@tuxdriver.com>
References: <469CE459.4070300@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <469CE459.4070300@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 17, 2007 at 10:46:33AM -0500, Larry Finger wrote:
> From: Jean Tourrilhes <jt@hpl.hp.com>
> 
> Victor Porton reported that the SoftMAC layer had random problem when 
> setting the ESSID :
> http://bugzilla.kernel.org/show_bug.cgi?id=8686 After investigation, it 
> turned out to be
> worse, the SoftMAC layer is left in an inconsistent state. The fix is 
> pretty trivial.
> 
> Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
> Acked-by: Michael Buesch <mb@bu3sch.df>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> This patch is now in Linus's tree and should now be added to 2.6.22.Y.

ACK for the stable guys.

John
-- 
John W. Linville
linville@tuxdriver.com
