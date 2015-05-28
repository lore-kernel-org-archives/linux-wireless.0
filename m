Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53949 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbbE1IgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 04:36:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [PATCHv4] add mt7601u driver
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1432631760-24135-1-git-send-email-moorray3@wp.pl>
To: Jakub Kici?ski <moorray3@wp.pl>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Message-Id: <20150528083624.D18E3140412@smtp.codeaurora.org> (sfid-20150528_103633_794224_648145F0)
Date: Thu, 28 May 2015 08:36:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Jakub Kicinski <kubakici@wp.pl>
> 
> Add support for the simplest of MediaTek Wi-Fi devices - MT7601U.
> It is a single stream bgn chip with no bells or whistles.
> This driver is partially based on Felix's mt76 but IMHO it doesn't
> make sense to merge the two right now because MT7601U is a design
> somewhere between old Ralink devices and new Mediatek chips.  There
> wouldn't be all that much code sharing with the devices mt76 supports.
> Situation may obviously change when someone decides to extend m76 with
> support for the more recent USB dongles.
> 
> The driver supports only station mode.  I'm hoping to add AP support
> when time allows.
> 
> This driver sat on GitHub for quite a while and got some testing there:
> http://github.com/kuba-moo/mt7601u
> 
> Signed-off-by: Jakub Kicinski <kubakici@wp.pl>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
