Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:24081 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191Ab1BKPYi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Feb 2011 10:24:38 -0500
Subject: Re: [PATCH 1/1] iwl3945: iwl3945_good_plcp_health might not used
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20110211144951.GA2278@redhat.com>
References: <1297354593-22897-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20110211144951.GA2278@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 07:22:49 -0800
Message-ID: <1297437769.20613.1300.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, 2011-02-11 at 06:49 -0800, Stanislaw Gruszka wrote:
> On Thu, Feb 10, 2011 at 08:16:33AM -0800, Wey-Yi Guy wrote:
> > remove plcp check for 3945, mark the function __maybe_unused
> > 
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > Cc: <stable@kernel.org> # .35+: c91d015: iwl3945: remove plcp check
> > Cc: stable@kernel.org  # 2.6.35+
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
I see your point, but I also think it des not mean other driver doing
bad, so we can do it too. do you agree? I like to see the iwlwifi driver
as clean as possible (do our best :-))

hope it is ok for you.

Wey

