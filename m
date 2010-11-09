Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:45805 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab0KIURb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 15:17:31 -0500
Subject: Re: [PATCH wireless-2.6] iwlwifi: dont use pci_dev before it being
 assign
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20101109193917.GC2374@tuxdriver.com>
References: <1289270721-31421-1-git-send-email-wey-yi.w.guy@intel.com>
	 <20101109193917.GC2374@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 09 Nov 2010 12:16:38 -0800
Message-Id: <1289333798.16859.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Tue, 2010-11-09 at 11:39 -0800, John W. Linville wrote:
> On Mon, Nov 08, 2010 at 06:45:21PM -0800, Wey-Yi Guy wrote:
> > In order to use build-in debugging macro, pci_dev in priv need to be
> > assigned first.
> > 
> > This fix iwl3945 driver oopsed at boot with 2.6.37-rc1
> > 
> > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> > this patch is also available from wireless-2.6 branch on
> >  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
> 
> I tried to pull this, but it seemed to be the wrong patch.  I manually
> applied the posted patch instead.
> 
Thanks so much, this patch is really needed.

Wey

