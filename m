Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:39610 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2F1Rc3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 13:32:29 -0400
Received: by gglu4 with SMTP id u4so2053660ggl.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jun 2012 10:32:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340889318.4491.45.camel@jlt3.sipsolutions.net>
References: <1340889318.4491.45.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 28 Jun 2012 10:32:07 -0700
Message-ID: <CAB=NE6WLQsTXs63zF-xGTr3PvODoD_UTLsQ2XX_gXHMJrOc_7Q@mail.gmail.com> (sfid-20120628_193232_718903_A70A25DE)
Subject: Re: [PATCH] compat-wireless: add patch to fix message tracing in mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 28, 2012 at 6:15 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Just like in iwlwifi, the tracing in mac80211 needs to
> copy va_args as some old kernels don't do it for %pV.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied and pushed, thanks!

  Luis
