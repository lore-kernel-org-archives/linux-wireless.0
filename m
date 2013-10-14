Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3JNOOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 10:14:51 -0400
Message-ID: <1381760087.13092.12.camel@jlt4.sipsolutions.net> (sfid-20131014_161454_804399_66503F1C)
Subject: Re: [PATCH v4 2/6] {nl,cfg,mac}80211: enable the triggering of CSA
 frame in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Mon, 14 Oct 2013 16:14:47 +0200
In-Reply-To: <1381516190-23918-3-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131011_203006_790076_081E6A34)
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1381516190-23918-3-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20131011_203006_790076_081E6A34)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 11:29 -0700, Chun-Yeow Yeoh wrote:
> Allow the triggering of CSA frame using mesh interface. The
> rules are more or less same with IBSS, such as not allowed to
> change between the band and channel width has to be same from
> the previous mode. Also, move the ieee80211_send_action_csa
> to a common space so that it can be re-used by mesh interface.

How will userspace know whether or not this is supported? Will it just
try and fail? Does it really not need to know?

johannes

