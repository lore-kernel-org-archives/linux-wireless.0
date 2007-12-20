Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:10888 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbXLTDWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 22:22:08 -0500
Received: by wa-out-1112.google.com with SMTP id v27so4956613wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 19 Dec 2007 19:22:08 -0800 (PST)
Message-ID: <1ba2fa240712191922x55675878o2ec3258419e1d4df@mail.gmail.com> (sfid-20071220_032212_563166_8652CC4F)
Date: Thu, 20 Dec 2007 05:22:01 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH] iwlwifi: proper monitor support
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Sam Leffler" <sam@errno.com>
In-Reply-To: <1198120544.3065.30.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1198052938-25637-1-git-send-email-yi.zhu@intel.com>
	 <1ba2fa240712191604l1f5343c0s62e66aaf2077cce1@mail.gmail.com>
	 <1ba2fa240712191608oa7f36e9ma05a04b4797d715a@mail.gmail.com>
	 <1198120544.3065.30.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 20, 2007 5:15 AM, Zhu Yi <yi.zhu@intel.com> wrote:
>
> On Thu, 2007-12-20 at 02:08 +0200, Tomas Winkler wrote:
> > I've made a mistake this is not logical but actual rate so it
> > theoretically we can go up to 600Mbs so it will make it 120 < 256.
>
> Um, should it be 1200 > 255?

Hmm I'm too long out of elementary school :)

> > But aren't we interested in MSC rate a packet was sent?
>
> NetBSD and wireshark support IEEE80211_RADIOTAP_XCHANNEL which does a
> better job to extend the IEEE80211_RADIOTAP_CHANNEL functions including
> per-channel power dbm, MCS rates, etc. Linux should catch up when we
> have 11n fully supported.
>
> Thanks,
> -yi
>
>
>
