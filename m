Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39653
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbYHQWMw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 18:12:52 -0400
Date: Sun, 17 Aug 2008 15:12:51 -0700 (PDT)
Message-Id: <20080817.151251.204370966.davem@davemloft.net> (sfid-20080818_001257_043576_AD5E23EC)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-17
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080817185605.GC30679@tuxdriver.com>
References: <20080817185605.GC30679@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Sun, 17 Aug 2008 14:56:06 -0400

> Here is the latest round of wireless fixes for 2.6.27.  The silliest one
> is the one from Adrian Bunk, which applies the gcc-related fix to ath9k
> again because there were two identical pieces of code to fix -- I guess
> I didn't get the joke *facepalm*...
> 
> I don't think there is anything else remarkable, although I think we fix
> a couple of the current regressions on LKML.

Two commits in here need a fixup.

Their commit messages reference SHA IDs but do not give a commit
header line text reference as well.

      p54: Fix regression due to commit b19fa1f
      ath5k: Don't fiddle with MSI on suspend/resume.

Please fix this up and give me another pull request, thanks!
