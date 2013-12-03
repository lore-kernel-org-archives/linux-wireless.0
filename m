Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43237 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3LCMuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 07:50:23 -0500
Message-ID: <1386075017.4393.11.camel@jlt4.sipsolutions.net> (sfid-20131203_135028_334079_4FAF7669)
Subject: Re: [PATCH] nl80211: allow the use of DFS channel in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Tue, 03 Dec 2013 13:50:17 +0100
In-Reply-To: <1385971550-4892-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131202_090631_339970_7D05571E)
References: <1385971550-4892-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20131202_090631_339970_7D05571E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-02 at 16:05 +0800, Chun-Yeow Yeoh wrote:
> This permits the use of DFS channel once the CAC is conducted and
> no radar is detected.

This seems pretty pointless right now? There's nothing supporting it, is
there?

johannes

