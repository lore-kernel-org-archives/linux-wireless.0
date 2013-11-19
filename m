Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab3KSOYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Nov 2013 09:24:18 -0500
Message-ID: <1384871053.15364.4.camel@jlt4.sipsolutions.net> (sfid-20131119_152424_982420_5EEFC582)
Subject: Re: [PATCH RESEND 2/5] mac80211: fix connection polling
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
Date: Tue, 19 Nov 2013 15:24:13 +0100
In-Reply-To: <20131119130414.GA1328@redhat.com>
References: <1384794166-10906-1-git-send-email-egrumbach@gmail.com>
	 <1384794409-11211-1-git-send-email-egrumbach@gmail.com>
	 <1384794409-11211-2-git-send-email-egrumbach@gmail.com>
	 <20131119130414.GA1328@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-11-19 at 14:04 +0100, Stanislaw Gruszka wrote:
> On Mon, Nov 18, 2013 at 07:06:46PM +0200, Emmanuel Grumbach wrote:
> > From: Eliad Peller <eliad@wizery.com>
> > 
> > Commit 392b9ff ("mac80211: change beacon/connection polling")
> > removed the IEEE80211_STA_BEACON_POLL flag.
> > 
> > However, it accidentally removed the setting of
> > IEEE80211_STA_CONNECTION_POLL, making the connection polling
> > completely useless (the flag is always clear, so the result
> > is never being checked). Fix it.
> 
> Good catch!
> 
> Johannes, this patch should be taken to 3.13 queue.

Alright, done.

johannes

