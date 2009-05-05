Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55444 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbZEEJws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 05:52:48 -0400
Date: Tue, 5 May 2009 12:52:36 +0300
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: Add a timeout for frames in the RX reorder
	buffer
Message-ID: <20090505095236.GA738@jm.kir.nu>
References: <20090430094100.GA23131@jm.kir.nu> <43e72e890905041650l72dad492q8d1380c1a489a3e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890905041650l72dad492q8d1380c1a489a3e4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 04, 2009 at 04:50:32PM -0700, Luis R. Rodriguez wrote:

> Been testing this for a while and it helps. How about splitting the
> add of ieee80211_release_reorder_frame() as a helper into a separate
> patch to make the work around clearer smaller and clearer?

Sure. I now have that and the #define for timeout value ready to go. I'm
hoping to run some more tests on these and various other things related
to the RX reorder buffer and then submit the patches.

-- 
Jouni Malinen                                            PGP id EFC895FA
