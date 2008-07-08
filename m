Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2803 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754618AbYGHTiO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 15:38:14 -0400
Date: Tue, 8 Jul 2008 15:01:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Howells <dhowells@redhat.com>
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
	akpm@linux-foundation.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Remove an extraneous label from the Intel Wifi driver
Message-ID: <20080708190130.GB30833@tuxdriver.com> (sfid-20080708_213828_345716_B9DCA5B0)
References: <20080708161514.9982.32985.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080708161514.9982.32985.stgit@warthog.procyon.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 08, 2008 at 05:15:14PM +0100, David Howells wrote:
> Remove an extraneous label from the Intel Wifi driver for which the goto has
> been removed.
> 
> The label was added in patch ad97edd2f524940d524c26ae273a4eb23067a7c0.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

FWIW, I've just merged another patch that takes care of freed_rfkill.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
