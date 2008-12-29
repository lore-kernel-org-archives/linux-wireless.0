Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbYL2KLj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 05:11:39 -0500
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1LHF62-0003un-2I
	for linux-wireless@vger.kernel.org; Mon, 29 Dec 2008 10:11:38 +0000
Date: Mon, 29 Dec 2008 05:11:38 -0500
From: Christoph Hellwig <hch@infradead.org>
To: linux-wireless@vger.kernel.org
Subject: subdirs under drivers/net/wireless
Message-ID: <20081229101138.GA15022@infradead.org> (sfid-20081229_111142_550654_AFAD09B2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like most multi-file drivers moved into subdirs in current git.

Any reason wavelan didn't get the same treatment?  Or do you plan to
kill that driver because it seems mostly dead..
