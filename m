Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab1BNJHr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 04:07:47 -0500
Date: Mon, 14 Feb 2011 10:06:49 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/1] iwl3945: iwl3945_good_plcp_health might not used
Message-ID: <20110214090620.GE2327@redhat.com>
References: <1297354593-22897-1-git-send-email-wey-yi.w.guy@intel.com>
 <20110211144951.GA2278@redhat.com>
 <1297437769.20613.1300.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297437769.20613.1300.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

On Fri, Feb 11, 2011 at 07:22:49AM -0800, wwguy wrote:
> On Fri, 2011-02-11 at 06:49 -0800, Stanislaw Gruszka wrote:
> > On Thu, Feb 10, 2011 at 08:16:33AM -0800, Wey-Yi Guy wrote:
> > > remove plcp check for 3945, mark the function __maybe_unused
> > > 
> > > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > Cc: <stable@kernel.org> # .35+: c91d015: iwl3945: remove plcp check
> > > Cc: stable@kernel.org  # 2.6.35+
> > > ---
> > >  drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
> > >  1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> I see your point, but I also think it des not mean other driver doing
> bad, so we can do it too. do you agree?

Fully agree :-)

> I like to see the iwlwifi driver
> as clean as possible (do our best :-))
> hope it is ok for you.

Of course it is. But I do not complained about fixing warning, but about
posting it to -stable. Thats clearly not -stable fix as stated in
Documentation/stable_kernel_rules.txt .

I should have add that __maybe_unused to my patch, but I didn't.
What we could do now is fix warning in upstream and live with it
in -stable .

Stanislaw
