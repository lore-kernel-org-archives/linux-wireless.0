Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49161 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbbCKTW6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 15:22:58 -0400
Message-ID: <1426101761.1904.10.camel@sipsolutions.net> (sfid-20150311_202321_194290_25235FB1)
Subject: Re: [PATCH RFC v2] ath10k: move code from parameter list into a
 function
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>, Valdis.Kletnieks@vt.edu,
	Bj??rn Mork <bjorn@mork.no>,
	Jeff Haran <Jeff.Haran@citrix.com>,
	Pat Erley <pat-lkml@erley.org>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Wed, 11 Mar 2015 20:22:41 +0100
In-Reply-To: <20150311191526.GA24455@opentech.at>
References: <1426100519-20636-1-git-send-email-hofrat@osadl.org>
	 <1426101010.1904.9.camel@sipsolutions.net>
	 <20150311191526.GA24455@opentech.at>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-11 at 20:15 +0100, Nicholas Mc Guire wrote:

> I'm not into this long enough to say what is better and if the consensus
> is that this patch is no more readable than the original code
> and no more maintainable either, then it is not worth the effort.

Personally, I like the change, it might even make that function more
reusable etc., and it gets rid of the ({ ... }) expression syntax which
I always find a bit odd :)

johannes

