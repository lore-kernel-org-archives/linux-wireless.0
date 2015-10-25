Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33842 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbbJYJOi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:14:38 -0400
Received: by lfaz124 with SMTP id z124so120420927lfa.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2015 02:14:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1445763582-11421-7-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
	<1445763582-11421-7-git-send-email-emmanuel.grumbach@intel.com>
Date: Sun, 25 Oct 2015 11:14:36 +0200
Message-ID: <CANUX_P0F6cjmkRxMv0yWtzhFWieq0OzvJVmccNTCNgDcW9nzGA@mail.gmail.com> (sfid-20151025_101451_686805_C8656E18)
Subject: Re: [PATCH 07/10] mac80211: allow driver to prevent two stations w/
 same address
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
> Some devices or drivers cannot deal with having the same station
> address for different virtual interfaces, say as a client to two
> virtual AP interfaces. Rather than requiring each driver with a
> limitation like that to enforce it, add a hardware flag for it.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---
>  include/net/mac80211.h  |  6 ++++++
>  net/mac80211/debugfs.c  |  1 +
>  net/mac80211/sta_info.c | 18 ++++++++++++++++--
>  3 files changed, 23 insertions(+), 2 deletions(-)
>

Got confused. You already sent this one.
