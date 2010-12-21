Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:18577 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932765Ab0LUJW5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 04:22:57 -0500
Subject: Re: [PATCH] wl12xx: remove redundant debugfs_remove_recursive()
 call
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1292406474-3238-1-git-send-email-eliad@wizery.com>
References: <1292406474-3238-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Dec 2010 11:22:54 +0200
Message-ID: <1292923374.19436.9.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-12-15 at 11:47 +0200, ext Eliad Peller wrote:
> Upon rmmod, the <debugfs>/ieee80211/phyX dir is being removed.
> later, we try to remove <debugfs>/ieee80211/phyX/wl12xx, which
> might result in NULL dereference.
> 
> Remove the excessive debugfs_remove_recursive() call.
> (consequently, there is no more need to save wl->rootdir)
> 
> Reported-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

