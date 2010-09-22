Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39490 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab0IVP3r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Sep 2010 11:29:47 -0400
Date: Wed, 22 Sep 2010 11:15:57 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Fwd: Re: [PATCH wireless-2.6] iwlwifi: do not perferm force
 reset while doing scan]
Message-ID: <20100922151557.GE5515@tuxdriver.com>
References: <1285166620.12056.29.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285166620.12056.29.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 22, 2010 at 07:43:40AM -0700, Guy, Wey-Yi wrote:

> The "iwlwifi: do not perferm force reset while doing scan" patch, make
> sense for .36, but after Gruszka's scan patch(which will in .37), it is
> not needed. What is your recommendation?
> 
> 
> commit#7acc7c683a747689aaaaad4fce1683fc3f85e552 iwlwifi: do not perferm
> force reset while doing scan

I can pull wireless-2.6 into wireless-next-2.6 and then revert the
patch there.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
