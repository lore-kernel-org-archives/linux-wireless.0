Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:53206 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422678AbXBUSB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Feb 2007 13:01:28 -0500
Date: Wed, 21 Feb 2007 19:01:23 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Fix ieee80211_ptr check
Message-ID: <20070221190123.66606886@griffin.suse.cz>
In-Reply-To: <200702201813.58453.flamingice@sourmilk.net>
References: <200702201813.58453.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 20 Feb 2007 18:13:54 -0500, Michael Wu wrote:
> dev->ieee80211_ptr can no longer be directly compared to check if a virtual
> interface belongs to a master device.

Hm, apparently the regexp I tried when resolving conflicts with John's
tree wasn't good enough to catch this :-(

Let's hope there are no more such things left.

Thanks for finding this,

 Jiri

-- 
Jiri Benc
SUSE Labs
