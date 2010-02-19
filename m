Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60213 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755993Ab0BSXPj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 18:15:39 -0500
Subject: Re: [PATCH 1/3] ath5k: remove stale function declarations, make
 some functions static
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <20100219134448.GA2844@tuxdriver.com>
References: <20100219012802.12460.42239.stgit@mj.roinet.com>
	 <20100219134448.GA2844@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 19 Feb 2010 18:15:25 -0500
Message-Id: <1266621325.25707.14.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-19 at 08:44 -0500, John W. Linville wrote:
> On Thu, Feb 18, 2010 at 08:28:02PM -0500, Pavel Roskin wrote:
> > Remove all unnecessary function declarations from ath5k.h.  Comment out
> > unused functions.  Remove ath5k_hw_get_tsf32(), which is too trivial to
> > be commented out.  Make functions static if suggested by sparse.  Make
> > ath5k_pm_ops static.
> 
> Any reason not to just remove those functions instead of commenting
> them out?

I'm fine either way.  I tend to clean up more aggressively if I know
that nobody will miss that code.  I wasn't sure in this case.

-- 
Regards,
Pavel Roskin
