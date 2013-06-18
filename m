Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3FRHcs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 03:32:48 -0400
Message-ID: <1371540696.8318.0.camel@jlt4.sipsolutions.net> (sfid-20130618_093306_674739_06FCD61A)
Subject: Re: [PATCH] mac80211: allow key deletion for mesh interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Tue, 18 Jun 2013 09:31:36 +0200
In-Reply-To: <1371528422-20710-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130618_060934_033197_015BA4A8)
References: <1371528422-20710-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130618_060934_033197_015BA4A8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-18 at 12:07 +0800, Chun-Yeow Yeoh wrote:
> This is to support key deletion for mesh interface, especially
> to be used for key which is not deleted even with the deletion
> of peer mesh station.

Can you explain which keys in mesh aren't deleted? It seems the
per-station keys would be deleted when the station is deleted, and
something like "GTK" would be deleted when leaving the mesh?

johannes

