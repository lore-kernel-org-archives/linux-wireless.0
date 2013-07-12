Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932878Ab3GLL7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 07:59:49 -0400
Message-ID: <1373630386.8205.5.camel@jlt4.sipsolutions.net> (sfid-20130712_135952_224505_2C486BA8)
Subject: Re: [PATCH] mac80211: fix off-by-one regression in ibss beacon
 generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 12 Jul 2013 13:59:46 +0200
In-Reply-To: <1373567389-6287-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1373567389-6287-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 20:29 +0200, Simon Wunderlich wrote:
> There is an off-by-one error in the beacon generation for the ibss mode,
> falsely a rate the extended supported rates which was already added to
> supported rates, messing up the beacon. This was introduced by commit
> "mac80211: select and adjust bitrates according to channel mode".

Applied.

johannes

