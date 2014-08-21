Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36770 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547AbaHUNKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 09:10:25 -0400
Message-ID: <1408626616.4388.0.camel@jlt4.sipsolutions.net> (sfid-20140821_151029_969304_4B843B0D)
Subject: Re: [PATCH v8 2/4] ath10k: provide firmware crash info via debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Thu, 21 Aug 2014 15:10:16 +0200
In-Reply-To: <20140821124907.27159.64620.stgit@potku.adurom.net> (sfid-20140821_144916_865910_8B25D7B4)
References: <20140821124705.27159.67898.stgit@potku.adurom.net>
	 <20140821124907.27159.64620.stgit@potku.adurom.net>
	 (sfid-20140821_144916_865910_8B25D7B4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-08-21 at 15:49 +0300, Kalle Valo wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Store the firmware registers and other relevant data to a firmware crash dump
> file and provide it to user-space via debugfs. Should help with figuring out
> why the firmware crashed.

So we just discussed Tuesday/yesterday that I'll be writing a generic
framework to provide this data to userspace, maybe you want to wait for
that.

johannes

