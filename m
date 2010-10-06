Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46374 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab0JFRsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 13:48:11 -0400
Subject: Re: [PATCH 1/6] iwlwifi: schedule to deprecate software scan
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20101006173609.GH2472@tuxdriver.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1286378593-7509-2-git-send-email-wey-yi.w.guy@intel.com>
	 <20101006173609.GH2472@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 19:48:06 +0200
Message-ID: <1286387286.3655.380.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 13:36 -0400, John W. Linville wrote:
> On Wed, Oct 06, 2010 at 08:23:08AM -0700, Wey-Yi Guy wrote:
> > Hardware scan is the prefer method for all iwlwifi devices;
> > especially for dual-mode functions. Schedule to deprecate the
> > software scan support in kernel 2.6.40
> > 
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> Hmmm...perhaps you have more confidence in this than I do?
> My experience suggests that hardware scanning has been the source of
> a number of problems and having the option to turn it off has provided
> a useful workaround for any number of users.

I think most issues with hw scanning have been the stuff that Stanislaw
has fixed.

johannes

