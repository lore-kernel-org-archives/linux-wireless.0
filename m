Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1F0UgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 16:36:21 -0400
Subject: Re: [PATCH] iwlagn: use PCI_DMA_* for pci_* operations
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com
In-Reply-To: <20110627200213.GD9166@tuxdriver.com> (sfid-20110627_221707_145393_4D84079F)
References: <1309204219-9579-1-git-send-email-linville@tuxdriver.com>
	 <20110627200213.GD9166@tuxdriver.com>
	 (sfid-20110627_221707_145393_4D84079F)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 22:36:22 +0200
Message-ID: <1309206982.3894.1.camel@jlt3.sipsolutions.net> (sfid-20110627_224048_124287_310B37CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-27 at 16:02 -0400, John W. Linville wrote:
> This would only be for 3.0, obviously.  It isn't really necessary,
> since the values are equal.  But, it seems wrong to misuse the API.

Doh, you're right of course -- should the function argument also have a
different type then?

johannes


