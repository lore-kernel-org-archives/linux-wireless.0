Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab3KSNFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 08:05:04 -0500
Date: Tue, 19 Nov 2013 14:04:14 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Eliad Peller <eliad@wizery.com>
Subject: Re: [PATCH RESEND 2/5] mac80211: fix connection polling
Message-ID: <20131119130414.GA1328@redhat.com> (sfid-20131119_140509_153393_37076DD4)
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
 <1384794409-11211-1-git-send-email-egrumbach@gmail.com>
 <1384794409-11211-2-git-send-email-egrumbach@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1384794409-11211-2-git-send-email-egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 18, 2013 at 07:06:46PM +0200, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Commit 392b9ff ("mac80211: change beacon/connection polling")
> removed the IEEE80211_STA_BEACON_POLL flag.
> 
> However, it accidentally removed the setting of
> IEEE80211_STA_CONNECTION_POLL, making the connection polling
> completely useless (the flag is always clear, so the result
> is never being checked). Fix it.

Good catch!

Johannes, this patch should be taken to 3.13 queue.

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
