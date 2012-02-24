Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445Ab2BXQBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 11:01:39 -0500
Subject: Re: [PATCH 1/6] iwlwifi: dump stack when fail to gain access to
 the device
From: Johannes Berg <johannes@sipsolutions.net>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linville@tuxdriver.com,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1330094743.7290.96.camel@wwguy-huron> (sfid-20120224_165643_875467_2922CAE6)
References: <1329992168-19990-1-git-send-email-sgruszka@redhat.com>
	 <1330008917.7290.92.camel@wwguy-huron>  <20120224093232.GA14496@redhat.com>
	 <1330094743.7290.96.camel@wwguy-huron>
	 (sfid-20120224_165643_875467_2922CAE6)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 17:01:25 +0100
Message-ID: <1330099285.3426.31.camel@jlt3.sipsolutions.net> (sfid-20120224_170332_978491_14A6DA98)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 06:45 -0800, Guy, Wey-Yi wrote:
> Hi Stanislaw,
> 
> On Fri, 2012-02-24 at 10:32 +0100, Stanislaw Gruszka wrote:
> > Hi
> > 
> > On Thu, Feb 23, 2012 at 06:55:17AM -0800, Guy, Wey-Yi wrote:
> > > We are doing major driver re-factor works internally, I understand your
> > > patches are important and these patches improve the quality of the
> > > driver. I just wonder if it is ok for you to allow us to merge your
> > > patches into our internal development tree first, then I will push these
> > > patches upstream for you. By doing so, we can make sure your patches can
> > > fully integrated with our on-going driver re-factor work and not cause
> > > any conflict.
> > No problem with that.
> > 
> Thank you so much for the understanding, now is critical time for us, we
> are doing huge amount of re-factor works and I will like to make it as
> smooth and as quick as possible.
> 
> btw, are you going to send another updated version of patches set to
> address Johannes's comments?

No need, I fixed these issues already.

johannes

