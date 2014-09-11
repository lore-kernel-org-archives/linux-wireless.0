Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57368 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaIKSPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 14:15:16 -0400
Date: Thu, 11 Sep 2014 14:11:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jade Bilkey <herself@thefumon.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath5k: added debugfs file for dumping eeprom
Message-ID: <20140911181148.GA22872@tuxdriver.com> (sfid-20140911_201520_697576_1E1DF4FA)
References: <20140906170048.GA32300@apiculture.lan>
 <20140909193237.GN29412@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140909193237.GN29412@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 09, 2014 at 03:32:38PM -0400, John W. Linville wrote:
> The original patch was already merged.  To make a change, you need
> to post a new patch based on the new head of the tree.  This one just
> conflicts with what is already there now.
> 
> Also, I think all you really need is a "#include <linux/vmalloc.h>".
> 
> Post a v3 that just adds the #include?

Nevermind, Dave M. already merged such a patch in net-next...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
