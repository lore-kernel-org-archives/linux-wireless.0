Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOk7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 09:40:59 -0500
Message-ID: <1353336088.18299.11.camel@jlt4.sipsolutions.net> (sfid-20121119_154102_757368_99FC8910)
Subject: Re: [PATCH] iw: add set_mcast_rate command support
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 15:41:28 +0100
In-Reply-To: <1352282283-31254-1-git-send-email-ordex@autistici.org>
References: <1352282283-31254-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-07 at 10:58 +0100, Antonio Quartulli wrote:
> This patch adds the support to run the set_mcast_rate() command on
> adhoc and mesh_point vifs. With this command it is possible to tune
> the bitrate to use when sending group frames. This command can be used
> even if the vifs has already joint the ibss/mesh network.

Applied.

johannes

