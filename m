Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hamlet.e18.physik.tu-muenchen.de ([129.187.154.223]:46213 "EHLO
	hamlet.e18.physik.tu-muenchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbZFGXhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 19:37:45 -0400
Message-ID: <4A2C47E1.4060606@ph.tum.de>
Date: Mon, 08 Jun 2009 01:06:09 +0200
From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, nbd@openwrt.org,
	rathamahata@gmail.com, ognjen.maric@gmail.com, rjw@sisk.pl,
	stable@kernel.org
Subject: Re: [PATCH] mac80211: fix minstrel single-rate memory corruption
References: <1244204510-14007-1-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244204510-14007-1-git-send-email-me@bobcopeland.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This fixes http://bugzilla.kernel.org/show_bug.cgi?id=12490 on the
> regression list (also http://bugzilla.kernel.org/show_bug.cgi?id=13000).

The patch works well.  No kernel panics anymore.  You made my day!

Thank you,

Thiemo
