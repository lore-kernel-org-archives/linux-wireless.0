Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56012 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbZKRQp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 11:45:26 -0500
Date: Wed, 18 Nov 2009 11:33:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH 3/3] ipw2200: Set core hw rfkill status when hardware
	changes state
Message-ID: <20091118163309.GD2911@tuxdriver.com>
References: <1258561550-20574-1-git-send-email-linville@tuxdriver.com> <1258561550-20574-2-git-send-email-linville@tuxdriver.com> <1258561550-20574-3-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1258561550-20574-3-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 11:25:50AM -0500, John W. Linville wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> ipw2200 is able to detect when it's been hard-killed, but doesn't update
> the core rfkill state or update userspace. Ensure that the state is updated,
> allowing the rfkill core to notify userspace.
> 
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

This one is unmodified from the original FWIW...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
