Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1C2O2u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 10:28:50 -0400
Date: Tue, 29 Mar 2011 16:28:25 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] iwlegacy: fix bugs in change_interface
Message-ID: <20110329142824.GA7320@redhat.com>
References: <1301400359.3834.12.camel@jlt3.sipsolutions.net>
 <20110329132231.GA6919@redhat.com>
 <1301405175.3834.15.camel@jlt3.sipsolutions.net>
 <1301405291.3834.16.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1301405291.3834.16.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 29, 2011 at 03:28:11PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If change_interface gets invoked during a firmware
> restart, it may crash; prevent that from happening
> by checking if ctx->vif is assigned.
> 
> Additionally, in my initial commit I forgot to set
> the vif->p2p variable correctly, so fix that too.
> 
> Cc: stable@kernel.org [2.6.38+]
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

ACK
