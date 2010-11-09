Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:49709 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab0KIVUZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 16:20:25 -0500
Subject: Re: [PATCH 0/8]  update for 2.6.38
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20101109211209.GD2374@tuxdriver.com>
References: <1287850546-23500-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20101109211209.GD2374@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 09 Nov 2010 13:18:12 -0800
Message-Id: <1289337492.17907.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Tue, 2010-11-09 at 13:12 -0800, John W. Linville wrote:
> On Sat, Oct 23, 2010 at 09:15:38AM -0700, Wey-Yi Guy wrote:
> > We make number of changes to prepare upcoming P2P supports
> > We also turn on dynamic smps to improve WiFi rx throughput
> > for WiFi/BT coex case.
> > We also change the new 130 series devices to using 6000g2b uCode
> > 
> > Johannes Berg (5):
> >   iwlwifi: make mac80211 ops a device config
> >   iwlagn: don't resent RXON timing
> >   iwlagn: new RXON processing for modern devices
> >   iwlwifi: fix IBSS beaconing
> >   iwlwifi: implement switching iftype while up
> > 
> > Wey-Yi Guy (3):
> >   iwlagn: turn dynamic smps on while BT is on
> >   iwlwifi: add new devices to Kconfig
> >   iwlagn: use 6000g2b uCode for 130 series devices
> > 
> > these patches are also available from wireless-next-2.6 branch on
> >  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
> 
> I figured-out what happened with that other pull request -- you put
> that patch on the wireless-next-2.6 branch instead of the wireless-2.6
> branch. :-(
> 
> I'll apply these manually to wireless-next-2.6...
> 
So sorry, my huge mistake, thanks for helping fix the problem,

Wey


