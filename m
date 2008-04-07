Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:9718 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930AbYDGVsS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 17:48:18 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1657008wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Apr 2008 14:48:17 -0700 (PDT)
Message-ID: <f6ca9fed0804071448j34419f9encba8fd42599b7d65@mail.gmail.com> (sfid-20080407_224837_498852_808CD33B)
Date: Mon, 7 Apr 2008 23:48:17 +0200
From: drago01 <drago01@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 1/2] mac80211: fix recursive locking in ieee80211_sta_expire
Cc: linville@tuxdriver.com,
	"Andrew Morton" <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Jiri Benc" <jbenc@suse.cz>
In-Reply-To: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1207598029-20000-1-git-send-email-jirislaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 7, 2008 at 9:53 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> Hi,
>
>  it's against -mm, what's current mac80211 git tree? It seems that
>  -mm has fresher material, than wireless-2.6...

The current tree is wireless-testing
