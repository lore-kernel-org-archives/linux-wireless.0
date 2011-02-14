Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16581 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1BNP7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 10:59:24 -0500
Subject: Re: [PATCH 1/1] iwl3945: iwl3945_good_plcp_health might not used
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1297698872.3953.8.camel@jlt3.sipsolutions.net>
References: <1297354593-22897-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1297677349.3785.3.camel@jlt3.sipsolutions.net>
	 <1297697139.4723.4.camel@wwguy-ubuntu>
	 <1297697334.3953.7.camel@jlt3.sipsolutions.net>
	 <1297698486.4723.15.camel@wwguy-ubuntu>
	 <1297698872.3953.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 07:57:33 -0800
Message-ID: <1297699053.4723.17.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-14 at 07:54 -0800, Johannes Berg wrote:
> On Mon, 2011-02-14 at 07:48 -0800, wwguy wrote:
> > On Mon, 2011-02-14 at 07:28 -0800, Johannes Berg wrote:
> > > On Mon, 2011-02-14 at 07:25 -0800, wwguy wrote:
> > > > On Mon, 2011-02-14 at 01:55 -0800, Johannes Berg wrote:
> > > > > On Thu, 2011-02-10 at 08:16 -0800, Wey-Yi Guy wrote:
> > > > > > remove plcp check for 3945, mark the function __maybe_unused
> > > > > 
> > > > > Why not remove the function instead?
> > > > > 
> > > > I guess we can remove it in legacy driver
> > > 
> > > But it's a 3945 specific function, and never used, so ...??
> > > 
> > I mean we should remove this function in legacy driver after driver
> > split
> 
> I just don't see why we can't remove it right now?
> 
we can do it for _stable, for mainstream, all 3945 will move to separate
driver anyway.

Wey
> 


