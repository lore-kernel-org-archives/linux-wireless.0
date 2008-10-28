Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:14088 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbYJ1MHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 08:07:54 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2572682wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 05:07:54 -0700 (PDT)
Message-ID: <1ba2fa240810280507y36443ec0nb62e4e9896911473@mail.gmail.com> (sfid-20081028_130804_542588_4E6F4BFE)
Date: Tue, 28 Oct 2008 14:07:53 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: [PATCH] mac80211: print reason code for deauth/dissoc frames
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20081028120059.GM19710@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225180711-5204-1-git-send-email-yi.zhu@intel.com>
	 <1ba2fa240810280431m21080a96i7655e67769cb1579@mail.gmail.com>
	 <20081028120059.GM19710@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 2:00 PM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Oct 28, 2008 at 01:31:13PM +0200, Tomas Winkler wrote:
>
>> Do anyone has idea how to push it to the user space?
>> We already use ieee80211_sta_send_apinfo (SIOCGIWAP) for notification.
>> Can be reason code attached without breaking user space?  The
>> iwreq_data it self has enough space to add this and this can be queued
>> at the end.
>
> Taken into account how broken WEXT events are already on 64/32-bit
> systems, it would probably be better to add this as a new nl80211 event
> which we will hopefully get in the near future. I'm looking for that to
> fix the association info reporting, too (and issue that I fixed with
> WEXT, but the fix was reverted due to userspace interop issues..).

Okay, thanks for the info. will look into nl direction.
Tomas
