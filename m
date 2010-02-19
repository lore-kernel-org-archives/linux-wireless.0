Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55215 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756100Ab0BSU7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 15:59:25 -0500
Subject: Re: [PATCH 3/3] iwlwifi: error checking for number of tfds in queue
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"stable@kernel.org" <stable@kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <20100219203420.GO4950@tuxdriver.com>
References: <1266559301-19581-1-git-send-email-reinette.chatre@intel.com>
	 <1266559301-19581-4-git-send-email-reinette.chatre@intel.com>
	 <20100219203420.GO4950@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Feb 2010 12:59:24 -0800
Message-ID: <1266613164.2551.2811.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-02-19 at 12:34 -0800, John W. Linville wrote:
> On Thu, Feb 18, 2010 at 10:01:41PM -0800, Reinette Chatre wrote:
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 
> > When receive reply_tx and ready to decrement the count for number of
> > tfds in queue, do error checking to prevent error condition and
> > tfds_in_queue become negative number.
> > 
> > This fix starts to address
> > http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2160 by preventing
> > the bad situation from propagation when it does occur. This is needed while
> > the cause of the decrement error is still traced.
> > 
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > CC: stable@kernel.org
> 
> Since this apparently doesn't amount to a fix for the cited issue,
> it doesn't seem worth pusing for 2.6.33 at the moment.  Should I take
> it in wireless-next-2.6?  Or hold-out for a corrected version?

A version addressing Stanislaw's feedback is on its way. I apologize for
the delay. This patch does fix one instance of the issue and we would
like this fix to be included.

Reinette

