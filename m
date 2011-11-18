Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52732 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab1KRObp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 09:31:45 -0500
Subject: Re: [PATCH 1/2] mac80211: Build TX radiotap header dynamically
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1318349335-22514-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111011_180933_749263_153C15F9)
References: <1318349335-22514-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111011_180933_749263_153C15F9)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 15:31:42 +0100
Message-ID: <1321626702.10266.59.camel@jlt3.sipsolutions.net> (sfid-20111118_153153_824619_1723E33F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 18:08 +0200, Helmut Schaa wrote:

> +	__le16 txflags;

> +	put_unaligned_le16(txflags, pos);

Please send a patch to fix this endian bug that sparse found.

johannes

