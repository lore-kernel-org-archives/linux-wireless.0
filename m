Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58254 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaJIONn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 10:13:43 -0400
Message-ID: <1412864019.1828.47.camel@jlt4.sipsolutions.net> (sfid-20141009_161354_870892_47E94B18)
Subject: Re: [PATCH v2] mac80211-hwsim: Add support for
 HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 09 Oct 2014 16:13:39 +0200
In-Reply-To: <1412857671-23273-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141009_142758_740231_0962183D)
References: <1412857671-23273-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141009_142758_740231_0962183D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-09 at 15:27 +0300, Jukka Rissanen wrote:
> Add support for new attribute HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE
> which can be set by the user space component. The attribute
> will cause the kernel to destroy all those radios that were
> created by a process if that process dies. The old behaviour
> i.e., radios are persistent is still the default.

Applied.

johannes

