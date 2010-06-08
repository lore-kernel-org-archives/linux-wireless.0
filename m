Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50442 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138Ab0FHNpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 09:45:11 -0400
Date: Tue, 8 Jun 2010 09:30:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kiran Divekar <dkiran@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH 1/3] Libertas: cfg80211 support
Message-ID: <20100608133040.GA2422@tuxdriver.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C04D6389ABB@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C04D6389ABB@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 04, 2010 at 11:20:18PM -0700, Kiran Divekar wrote:
> Holger Schurig's patch (https://patchwork.kernel.org/patch/64286/)
> is rebased to latest wireless-testing tree.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Kiran Divekar <dkiran@marvell.com>
> Tested-by: Amitkumar Karwar <akarwar@marvell.com>

I think that your 'latest wireless-testing tree' is not up-to-date.
Please ensure that your local tree has the following commit:

commit 77c2061d10a408d0220c2b0e7faefe52d9c41008
Author: Walter Goldens <goldenstranger@yahoo.com>
Date:   Tue May 18 04:44:54 2010 -0700

    wireless: fix several minor description typos
    
    Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

I really want your patch, but as presented it fails to apply so
spectacularly that I'm afraid to even start trying to fix it up. :-(

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
