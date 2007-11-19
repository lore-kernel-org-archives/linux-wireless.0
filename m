Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:58277 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbXKSTUw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 14:20:52 -0500
Date: Mon, 19 Nov 2007 11:10:09 -0800
From: Greg KH <greg@kroah.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Saleem Abdulrasool <compnerd@compnerd.org>,
	"John W.Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, chrisw@sous-sol.org,
	stable@kernel.org
Subject: Re: [PATCH] iwlwifi: fix possible NULL dereference in
	iwl_set_rate()
Message-ID: <20071119191009.GB9115@kroah.com> (sfid-20071119_192100_564181_766C907A)
References: <20071119075908.GA958@compnerd.org> <1195460046.3250.380.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1195460046.3250.380.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 19, 2007 at 04:14:06PM +0800, Zhu Yi wrote:
> On Sun, 2007-11-18 at 23:59 -0800, Saleem Abdulrasool wrote:
> > As per Zhu Yi's request, Im forwarding along a patch for CVE-2007-5938, a NULL
> > dereference vulnerability in the iwlwifi driver.  All current versions are
> > effected by this.
> 
> ACK.

Please let the stable@kernel.org address know when this patch goes into
Linus's tree, so that we can apply it there.

thanks,

greg k-h
