Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43840 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbZCXOAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 10:00:53 -0400
Date: Tue, 24 Mar 2009 09:47:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
Subject: Re: wireless powersaving (in NM?)
Message-ID: <20090324134719.GA19335@tuxdriver.com> (sfid-20090324_150055_791722_E1D37FF3)
References: <1237891149.4320.73.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1237891149.4320.73.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 11:39:09AM +0100, Johannes Berg wrote:

> However, by putting the burden onto drivers, drivers can choose a
> conservative power saving level when no application has registered its
> pm_qos requirements, and once applications start using the it deeper
> power levels can be chosen as appropriate. This still requires some
> userspace to turn on power saving to start with, which I think would be
> appropriately placed in NM (or connman, of course).

I think you've made a good case for pushing the power savings decisions
onto the drivers.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
