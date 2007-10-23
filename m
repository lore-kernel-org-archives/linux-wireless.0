Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48492 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751029AbXJWBId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2007 21:08:33 -0400
Subject: Re: [PATCH] ipw2200: batch non-user-requested scan result
	notifications
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, ipw2100-devel@lists.sourceforge.net
In-Reply-To: <1193068039.30205.13.camel@localhost.localdomain>
References: <1191952524.617.7.camel@localhost.localdomain>
	 <1193042719.3069.166.camel@debian.sh.intel.com>
	 <1193068039.30205.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 08:58:31 +0800
Message-Id: <1193101111.3069.178.camel@debian.sh.intel.com> (sfid-20071023_020837_193481_4DEF5C8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-10-22 at 11:47 -0400, Dan Williams wrote:
> I think that it got fixed upstream when the round_jiffies_relative()
> patch went it, is that what you mean? 

Yeah, that's what I mean. Thank you for the patch.

-yi
