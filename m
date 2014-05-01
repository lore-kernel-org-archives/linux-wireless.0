Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39729 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaEAHzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 03:55:39 -0400
Received: by mail-pd0-f171.google.com with SMTP id r10so2832030pdi.16
        for <linux-wireless@vger.kernel.org>; Thu, 01 May 2014 00:55:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1398928648-5052-1-git-send-email-arik@wizery.com>
References: <1398928648-5052-1-git-send-email-arik@wizery.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 1 May 2014 10:55:23 +0300
Message-ID: <CA+XVXfe9yihH1wV2K-ROYcvP-v-Rb0UeTOo0TbtAAgGJU64J9Q@mail.gmail.com> (sfid-20140501_095619_164673_B6F8FC20)
Subject: Re: [PATCH 1/2] mac80211: set an external flag for TDLS stations
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 1, 2014 at 10:17 AM, Arik Nemtsov <arik@wizery.com> wrote:
>
> expose a new tdls flag for the public ieee80211_sta struct. This is used
> in some rate control decisions.
>
> Change-Id: Ida05ae03feecb53d00d2d3947c0d314526a8a88d
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
> ---

Sorry for the change-id crap in both patches :)

Arik
