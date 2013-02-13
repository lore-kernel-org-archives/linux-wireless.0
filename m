Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50556 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3BMJLX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 04:11:23 -0500
Message-ID: <1360746678.8868.3.camel@jlt4.sipsolutions.net> (sfid-20130213_101128_646631_934500D3)
Subject: Re: [PATCH v2] nl80211: add packet offset information for wowlan
 pattern
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 13 Feb 2013 10:11:18 +0100
In-Reply-To: <1360700187-22806-1-git-send-email-bzhao@marvell.com>
References: <1360700187-22806-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 12:16 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> If user knows the location of a wowlan pattern to be matched in
> Rx packet, he can provide an offset with the pattern. This will
> help drivers to ignore initial bytes and match the pattern
> efficiently.

Applied, thanks. I refactored the pattern sending a bit to make it less
indented.

johannes

