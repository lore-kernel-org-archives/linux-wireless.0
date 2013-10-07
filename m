Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57628 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3JGQRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 12:17:05 -0400
Message-ID: <1381162599.9005.3.camel@jlt4.sipsolutions.net> (sfid-20131007_181713_925524_15E27908)
Subject: Re: [PATCH] mac80211: Use ERR_CAST inlined function instead of
 ERR_PTR(PTR_ERR(...))
From: Johannes Berg <johannes@sipsolutions.net>
To: djduanjiong@gmail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Duan Jiong <duanj.fnst@cn.fujitsu.com>
Date: Mon, 07 Oct 2013 18:16:39 +0200
In-Reply-To: <1381190953-6362-1-git-send-email-duanj.fnst@cn.fujitsu.com> (sfid-20131007_181007_863270_C3FC10D8)
References: <1381190953-6362-1-git-send-email-duanj.fnst@cn.fujitsu.com>
	 (sfid-20131007_181007_863270_C3FC10D8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-07 at 17:09 -0700, djduanjiong@gmail.com wrote:

>  	if (IS_ERR(key))
> -		return ERR_PTR(PTR_ERR(key));
> +		return ERR_CAST(key);

I already have this patch in my tree.

johannes

