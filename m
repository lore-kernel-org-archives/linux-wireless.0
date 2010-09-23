Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:8653 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab0IWOsP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 10:48:15 -0400
Subject: Re: [Fwd: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force
 reset while doing scan]
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20100922151557.GE5515@tuxdriver.com>
References: <1285166620.12056.29.camel@wwguy-huron>
	 <20100922151557.GE5515@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 23 Sep 2010 07:47:25 -0700
Message-Id: <1285253245.1382.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-22 at 08:15 -0700, John W. Linville wrote:
> On Wed, Sep 22, 2010 at 07:43:40AM -0700, Guy, Wey-Yi wrote:
> 
> > The "iwlwifi: do not perferm force reset while doing scan" patch, make
> > sense for .36, but after Gruszka's scan patch(which will in .37), it is
> > not needed. What is your recommendation?
> > 
> > 
> > commit#7acc7c683a747689aaaaad4fce1683fc3f85e552 iwlwifi: do not perferm
> > force reset while doing scan
> 
> I can pull wireless-2.6 into wireless-next-2.6 and then revert the
> patch there.
> 
Thank you very much for the help!

Wey

