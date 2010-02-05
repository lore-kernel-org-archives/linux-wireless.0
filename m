Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932913Ab0BEHA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 02:00:29 -0500
Subject: Re: [PATCH v2] airo: fix setting zero length WEP key
From: Dan Williams <dcbw@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Chris Siebenmann <cks-rhbugzilla@cs.toronto.edu>
In-Reply-To: <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com>
References: <1265121290-2969-1-git-send-email-sgruszka@redhat.com>
	 <20100204120713.GB6068@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 22:59:38 -0800
Message-ID: <1265353178.11066.5.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, can we revert the patch you applied, and apply the following patch
instead (in the next mail)?  I'd rather use the one I'm about to send
because it makes it clearer *why* setting the TX key index is required,
and it limits that case to only the time when it's necessary.  Pending
the testing by Chris, I'd rather have the revised version committed
instead.

Thanks,
Dan


