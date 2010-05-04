Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60442 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933642Ab0EDUOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 16:14:12 -0400
Subject: Re: mac80211/ath9k: HT rates in Mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Mathieu Olivari <Mathieu.Olivari@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100504195211.GG2624@tux>
References: <93781E992CBA7843962D8B0E7D683F3C1116C465A6@SC1EXMB-MBCL.global.atheros.com>
	 <20100504194348.GD2624@tux>
	 <93781E992CBA7843962D8B0E7D683F3C1116C465EA@SC1EXMB-MBCL.global.atheros.com>
	 <20100504195211.GG2624@tux>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 May 2010 22:14:07 +0200
Message-ID: <1273004047.3673.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-04 at 12:52 -0700, Luis R. Rodriguez wrote:
> Cc'ing linux-wireless.
> 
> On Tue, May 04, 2010 at 12:45:36PM -0700, Mathieu Olivari wrote:
> > BTW, do you know if HT is supported in Mesh ?
> 
> This would involve doing the same as for IBSS that Benoit
> is doing, someone with good will would have to do it. It should
> be fairly easy to review the patches implemented by Benoit to
> port to Mesh but there may be some unresolved things I may be
> overlooking.

Last I heard mesh wasn't supporting HT at all due to whatever issues?
Maybe protection or something?

johannes

