Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab3KDOOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 09:14:19 -0500
Message-ID: <1383574454.14295.13.camel@jlt4.sipsolutions.net> (sfid-20131104_151435_462544_36095D1B)
Subject: Re: [PATCH v2 1/3] mac80211_hwsim: use debugfs_remove_recursive
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Nov 2013 15:14:14 +0100
In-Reply-To: <1383334560-10672-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131101_203628_172788_3DC6CA5D)
References: <1383334560-10672-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131101_203628_172788_3DC6CA5D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-11-01 at 20:35 +0100, Janusz Dziedzic wrote:
> Use debugfs_remove_recursive. That avoids the need
> for the new dentry pointers and extra debugfs_remove
> calls.

All applied, thanks.

johannes

