Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:55803 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753828AbYKIETe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 23:19:34 -0500
Date: Sat, 8 Nov 2008 20:18:08 -0800
From: Greg KH <greg@kroah.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: stable@kernel.org, rjw@sisk.pl, linville@tuxdriver.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [stable] [PATCH 0/2] iwlwifi fixes for stable 2.6.27
Message-ID: <20081109041808.GA1017@kroah.com> (sfid-20081109_051946_489257_DAD7A74B)
References: <1226191867-22324-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1226191867-22324-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 09, 2008 at 02:51:05AM +0200, Tomas Winkler wrote:
> First one didn't make it into the stable due to type in emails
> Second is important bug fix that was kept out 2.6.27 merging window. 
> There is no visible kernel bug but w/o this patch the 5000 iwlwifi HW  
> is left un-calibrated which is critical

Are these already in Linus's tree?  If so, do you have a git commit id
for them?

thanks,

greg k-h
