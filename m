Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6361 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754330Ab1FBUAV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 16:00:21 -0400
Subject: Re: [PATCH] iwlagn: fix interface combinations
From: wwguy <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20110602194936.GB2511@tuxdriver.com>
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1306510833-32049-8-git-send-email-wey-yi.w.guy@intel.com>
	 <20110602162241.GE4580@redhat.com> <1307033971.14344.4.camel@wwguy-ubuntu>
	 <1307036323.3738.3.camel@jlt3.sipsolutions.net>
	 <20110602194936.GB2511@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Jun 2011 12:56:52 -0700
Message-ID: <1307044612.14344.182.camel@wwguy-ubuntu> (sfid-20110602_220031_791871_68A6994C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-02 at 12:49 -0700, John W. Linville wrote:
> On Thu, Jun 02, 2011 at 07:38:43PM +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > My patch to advertise interface combinations
> > worked by pure luck in the P2P case, but all
> > other cases are broken. This is due to a dumb
> > mistake in the code that checks what should
> > be advertised, fix that.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> I swear, I thought I had taken it out of my queue.  I'm getting old... :-(
> 
> > ---
> > Alternatively, this fixes it. Sorry.
> 
> I'd rather just apply this -- any objections?

It works, thanks
My mistake to push and ask revert at the first place, sorry :-(

Wey



