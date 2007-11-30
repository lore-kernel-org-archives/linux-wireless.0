Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49809
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760198AbXK3QUo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 11:20:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFT] [PATCH v4] b43: fix calc_nrssi_slope
Date: Fri, 30 Nov 2007 17:19:12 +0100
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20071129043957.739b4d3f@morte> <20071129215139.60ae663a@morte> <20071129220654.6c0c0d35@morte>
In-Reply-To: <20071129220654.6c0c0d35@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711301719.13245.mb@bu3sch.de> (sfid-20071130_162055_173998_1C7918CD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 29 November 2007 22:06:54 Stefano Brivio wrote:
> Fix calc_nrssi_slope() which caused PHY TX errors on devices containing a
> 802.11a PHY. The code is synced to v4 specs and relevant registers are
> renamed accordingly.
> 
> 
> Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
> 
> ---

That patch looks good, though I did not test it, yet.

John, please don't apply this, yet. It needs a lot more testing on
several different devices. In the past we had this kind of rewrite patches
already improve one device and completely break another.

So, people, please try this and check if it causes any regressions.

Thanks.

-- 
Greetings Michael.
