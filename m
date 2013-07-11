Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3GKK7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 06:59:16 -0400
Message-ID: <1373540349.8201.10.camel@jlt4.sipsolutions.net> (sfid-20130711_125919_209715_8A814951)
Subject: Re: [PATCH v2] nl80211: fix the setting of RSSI threshold value for
 mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Thu, 11 Jul 2013 12:59:09 +0200
In-Reply-To: <1373538243-17628-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130711_123105_640193_C6D7985F)
References: <1373538243-17628-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130711_123105_640193_C6D7985F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 18:24 +0800, Chun-Yeow Yeoh wrote:
> RSSI threshold value used for mesh peering should be in
> negative value. After range checks to mesh parameters is
> introduced, this is not allowed. Fix this.

Applied.

johannes

