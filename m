Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab2KZKb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 05:31:57 -0500
Message-ID: <1353925944.9488.10.camel@jlt4.sipsolutions.net> (sfid-20121126_113200_519168_5B0F7404)
Subject: Re: [PATCH] mac80211: in ADHOC don't update last_rx if sta is not
 authorized
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@open-mesh.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 26 Nov 2012 11:32:24 +0100
In-Reply-To: <1353881622-9279-1-git-send-email-antonio@open-mesh.com>
References: <1353881622-9279-1-git-send-email-antonio@open-mesh.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-11-25 at 23:13 +0100, Antonio Quartulli wrote:
> It does not make sense to keep a station alive if it is not authorised
> at all. If IBSS/RSN is used it could also be the case that something
> went wrong during the keys exchange and the stations ended up in a not
> recoverable state.
> 
> By not updating last_rx we are giving the station a chance to be
> deleted and to start the key exchange once again from scratch.

Applied.

johannes

