Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934188Ab3BTKLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 05:11:12 -0500
Message-ID: <1361355062.8629.19.camel@jlt4.sipsolutions.net> (sfid-20130220_111121_687023_C87DAFAC)
Subject: Re: [PATCH v2] mac80211: fix the problem of forwarding from DS to
 DS in Mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, thomas@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org,
	cedric.voncken@acksys.fr
Date: Wed, 20 Feb 2013 11:11:02 +0100
In-Reply-To: <1361239490-4630-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20130219_033534_345033_3800D03B)
References: <1361239490-4630-1-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20130219_033534_345033_3800D03B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-19 at 10:04 +0800, Chun-Yeow Yeoh wrote:
> Unicast frame with unknown forwarding information always trigger
> the path discovery assuming destination is always located inside the
> MBSS. This patch allows the forwarding to look for mesh gate if path
> discovery inside the MBSS has failed.
> 
> Reported-by: Cedric Voncken <cedric.voncken@acksys.fr>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
> v2: rebase on mac80211-next and redefine the logic clearer (Johannes & Thomas)

Applied.

FWIW, I'm ok with removing the path right there, it just seemed odd to
me on first glance.

johannes

