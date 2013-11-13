Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43496 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758394Ab3KMIm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 03:42:59 -0500
Message-ID: <1384332165.14578.1.camel@jlt4.sipsolutions.net> (sfid-20131113_094318_597810_85D443E0)
Subject: Re: [PATCH] mac80211: use put_unaligned_le16 in mesh_plink_frame_tx
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Wed, 13 Nov 2013 09:42:45 +0100
In-Reply-To: <1384328583-24639-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20131113_084628_447012_D58FC911)
References: <1384328583-24639-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20131113_084628_447012_D58FC911)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 15:43 +0800, Chun-Yeow Yeoh wrote:
> Use put_unaligned_le16 in mesh_plink_frame_tx.

Nice, applied both.

johannes

