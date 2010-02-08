Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48864 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0BHVAy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 16:00:54 -0500
Date: Mon, 8 Feb 2010 15:55:04 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
Subject: Re: [PATCH v2] airo: fix setting zero length WEP key
Message-ID: <20100208205503.GB3852@tuxdriver.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com> <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com> <1265353178.11066.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1265353178.11066.5.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 04, 2010 at 10:59:38PM -0800, Dan Williams wrote:
> John, can we revert the patch you applied, and apply the following patch
> instead (in the next mail)?  I'd rather use the one I'm about to send
> because it makes it clearer *why* setting the TX key index is required,
> and it limits that case to only the time when it's necessary.  Pending
> the testing by Chris, I'd rather have the revised version committed
> instead.

Do you still want this don, even after Chris's testing says your
patch doesn't work?  I wasn't sure from your response.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
