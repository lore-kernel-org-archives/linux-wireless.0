Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40325 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab2AIPng (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 10:43:36 -0500
Subject: Re: [PATCH RFC] iwlwifi: add basic runtime PM support
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, ilw@linux.intel.com,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1326100270.3451.5.camel@jlt3.sipsolutions.net>
References: <4F065F59.2070107@intel.com>
	 <1325843269.3330.4.camel@jlt3.sipsolutions.net>
	 <4F0A3C62.6010403@intel.com> <1326069251.13074.360.camel@wwguy-huron>
	 <4F0A492A.5080504@intel.com>  <1326071127.13074.367.camel@wwguy-huron>
	 <1326100270.3451.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 06:39:59 -0800
Message-ID: <1326119999.13074.369.camel@wwguy-huron> (sfid-20120109_164341_076712_006A3872)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-09 at 10:11 +0100, Johannes Berg wrote:
> On Sun, 2012-01-08 at 17:05 -0800, Guy, Wey-Yi wrote:
> 
> 
> > I understand, but unless we figure out either make rkill interrupt works
> > in runtime PM, or figure out the platform does not has HW RFKILL
> > automatically, I don't see how this patch can upstream without generate
> > a lot of issues and bug reports.
> 
> I suppose the question is -- will any tools/users enable it and then
> scream about their rfkill?
> 
> Maybe we can use pm_runtime_forbid() to disable it completely, and add a
> module parameter or something to enable it -- just so people are aware
> of the tradeoffs?

module parameter shall works, we just need a clear and easy way to allow
user enable/disable this runtime PM feature and not making mistake

Wey
> 


