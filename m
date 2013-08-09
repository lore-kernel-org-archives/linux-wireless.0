Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758289Ab3HINNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 09:13:47 -0400
Message-ID: <1376054020.8355.5.camel@jlt4.sipsolutions.net> (sfid-20130809_151351_589815_888AC6A1)
Subject: Re: [PATCH v3] mac80211: allow lowest basic rate for unicast
 management for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org
Date: Fri, 09 Aug 2013 15:13:40 +0200
In-Reply-To: <1375828796-17877-1-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130807_004018_215215_DE229937)
References: <1375828796-17877-1-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20130807_004018_215215_DE229937)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-06 at 15:39 -0700, Chun-Yeow Yeoh wrote:
> Allow lowest basic rate to be used for unicast management frame in
> mesh. Otherwise, the lowest supported rate is used for unicast
> management frame, such as 1Mbps for 2.4GHz and 6Mbps for 5GHz. Rename
> the rc_send_low_broadcast to re_send_low_basicrate since now it is
> also applied to unicast management frame in mesh.

Applied.

johannes

