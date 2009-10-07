Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44436 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759921AbZJGTqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 15:46:47 -0400
Date: Wed, 7 Oct 2009 15:41:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7/7] ath5k: enable Power-Save Polls by setting the
	association ID
Message-ID: <20091007194148.GC22394@tuxdriver.com>
References: <1254876274-1145-1-git-send-email-lrodriguez@atheros.com> <1254876274-1145-8-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1254876274-1145-8-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 06, 2009 at 08:44:34PM -0400, Luis R. Rodriguez wrote:
> mac80211 has long provided us the association ID. This isn't useful except
> for Power-Save polling which now gets enabled. We can now poll for our
> pending frames on the AP during power save.
> 
> You can review the details of Power-Save on the wireless wiki:
> 
> http://wireless.kernel.org/en/developers/Documentation/ieee80211/power-savings
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Nice try, but how is this a fix? :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
