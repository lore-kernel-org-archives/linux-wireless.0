Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1HJNjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:39:22 -0400
Subject: Re: [PATCH 2/8] mac80211: fix mpath timer NULL function
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <1312933511-9486-3-git-send-email-thomas@cozybit.com> (sfid-20110810_014657_781248_7AF08BC7)
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	 <1312933511-9486-3-git-send-email-thomas@cozybit.com>
	 (sfid-20110810_014657_781248_7AF08BC7)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:39:19 +0200
Message-ID: <1312983559.4325.2.camel@jlt3.sipsolutions.net> (sfid-20110810_153923_989897_7A439D01)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 16:45 -0700, Thomas Pedersen wrote:
> From: Javier Cardona <javier@cozybit.com>
> 
> If we have an mpath whose timer has not been initialized, don't try to
> delete it.

IMHO this doesn't make sense -- always initialising the timer but not
adding it when not necessary seems better?

johannes

