Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaBKL7s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Feb 2014 06:59:48 -0500
Message-ID: <1392119984.4128.3.camel@jlt4.sipsolutions.net> (sfid-20140211_125956_474755_DFF32E70)
Subject: Re: [PATCH] mac80211: fix memory leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Eytan Lifshitz <eytan.lifshitz@intel.com>
Date: Tue, 11 Feb 2014 12:59:44 +0100
In-Reply-To: <1391713292-7378-1-git-send-email-egrumbach@gmail.com> (sfid-20140206_200139_386800_86C4464B)
References: <1391713292-7378-1-git-send-email-egrumbach@gmail.com>
	 (sfid-20140206_200139_386800_86C4464B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-06 at 21:01 +0200, Emmanuel Grumbach wrote:
> From: Eytan Lifshitz <eytan.lifshitz@intel.com>
> 
> In case ieee80211_prep_connection() fails to dereference
> sdata->vif.chanctx_conf, the function returns and doesn't
> free new_sta. fixed.

Applied.

johannes

