Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:34948 "EHLO
	mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbbJYJOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:14:55 -0400
Received: by lfbn126 with SMTP id n126so85500533lfb.2
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2015 02:14:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1445763582-11421-5-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
	<1445763582-11421-5-git-send-email-emmanuel.grumbach@intel.com>
Date: Sun, 25 Oct 2015 11:14:53 +0200
Message-ID: <CANUX_P3d1uPQfDwucxG5_-nw44__bgHLSrsCVqADdzjwDy1TZw@mail.gmail.com> (sfid-20151025_101458_553426_5059D550)
Subject: Re: [PATCH 05/10] mac80211: make enable_qos parameter to ieee80211_set_wmm_default()
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 25, 2015 at 10:59 AM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> The function currently determines this value, for use in bss_info.qos,
> based on the interface type itself. Make it a parameter instead and
> set it with the same logic for now.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Got confused. You already sent this one.
