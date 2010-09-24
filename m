Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40638 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265Ab0IXSOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 14:14:37 -0400
Date: Fri, 24 Sep 2010 14:03:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-omap@vger.kernel.org, tony@atomide.com,
	linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: Re: [PATCH v3] omap: beagle: add support for wl1271 on the board file
Message-ID: <20100924180316.GE8077@tuxdriver.com>
References: <1285236215-21136-1-git-send-email-luciano.coelho@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285236215-21136-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 01:03:35PM +0300, Luciano Coelho wrote:
> Add board configuration for the wl1271 daughter board.  This patch is based
> on Ohad Ben-Cohen's patches for Zoom boards.
> 
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> ---
> from v2 to v3: removed accidental change to wl1271.h

I presume that this should come through my tree as well (since it
contains the move of wl12xx.h)?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
