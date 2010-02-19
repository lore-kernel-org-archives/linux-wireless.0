Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50883 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab0BSNpk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 08:45:40 -0500
Date: Fri, 19 Feb 2010 08:44:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] ath5k: remove stale function declarations, make
	some functions static
Message-ID: <20100219134448.GA2844@tuxdriver.com>
References: <20100219012802.12460.42239.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100219012802.12460.42239.stgit@mj.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 18, 2010 at 08:28:02PM -0500, Pavel Roskin wrote:
> Remove all unnecessary function declarations from ath5k.h.  Comment out
> unused functions.  Remove ath5k_hw_get_tsf32(), which is too trivial to
> be commented out.  Make functions static if suggested by sparse.  Make
> ath5k_pm_ops static.

Any reason not to just remove those functions instead of commenting
them out?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
