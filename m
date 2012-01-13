Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54637 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2AMPQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 10:16:09 -0500
Date: Fri, 13 Jan 2012 10:05:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sam Leffler <sleffler@chromium.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: support fixed rate packet injection
Message-ID: <20120113150540.GA18899@tuxdriver.com> (sfid-20120113_161614_610941_BBACB31A)
References: <20120113000525.4226F5819C@lefflers.sfo.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120113000525.4226F5819C@lefflers.sfo.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2012 at 09:53:36AM -0800, Sam Leffler wrote:
> Support setting the transmit rate, flags, and try count for
> injected packets by parsing the IEEE80211_RADIOTAP_RATE,
> IEEE80211_RADIOTAP_DATA_RETRIES, and IEEE80211_RADIOTAP_MCS radiotap tags.
> 
> Change-Id: Id5f3df0424e9a4a584cd565ffa6df35efedb8071

Not sure what this is?

Anyway, you are missing the Signed-off-by line.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
