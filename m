Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab0BHXpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 18:45:30 -0500
Subject: Re: [PATCH v2] airo: fix setting zero length WEP key
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
In-Reply-To: <20100208205503.GB3852@tuxdriver.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com>
	 <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com>
	 <1265353178.11066.5.camel@localhost.localdomain>
	 <20100208205503.GB3852@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 15:44:47 -0800
Message-ID: <1265672687.15235.41.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-02-08 at 15:55 -0500, John W. Linville wrote:
> On Thu, Feb 04, 2010 at 10:59:38PM -0800, Dan Williams wrote:
> > John, can we revert the patch you applied, and apply the following patch
> > instead (in the next mail)?  I'd rather use the one I'm about to send
> > because it makes it clearer *why* setting the TX key index is required,
> > and it limits that case to only the time when it's necessary.  Pending
> > the testing by Chris, I'd rather have the revised version committed
> > instead.
> 
> Do you still want this don, even after Chris's testing says your
> patch doesn't work?  I wasn't sure from your response.

Not yet, no.  I'd like to work out the issue first, if we can.

Thanks,
Dan


