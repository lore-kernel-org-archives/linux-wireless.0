Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37574 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1GYU1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 16:27:49 -0400
Received: by qyk29 with SMTP id 29so1078644qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 13:27:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110715173306.GE2566@tuxdriver.com>
References: <1310399981.11331.4.camel@sven> <1310478727-12099-2-git-send-email-s.neumann@raumfeld.com>
 <20110715173306.GE2566@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Jul 2011 13:27:28 -0700
Message-ID: <CAB=NE6V4ZAkjMZo37s2RqvMTAieXQMX51sE7SeU-bzoHxSZEdA@mail.gmail.com> (sfid-20110725_222752_323138_6DDD5B22)
Subject: Re: [PATCH] cfg80211: really ignore the regulatory request
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sven Neumann <s.neumann@raumfeld.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Mack <daniel@zonque.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 10:33 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> Luis, ping?

Looks good, but please also add Cc: stable@kernel.org so this
propagates to stable kernels.

  Luis
