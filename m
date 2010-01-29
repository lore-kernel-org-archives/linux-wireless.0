Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:49628 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab0A2SI1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 13:08:27 -0500
Received: by pzk2 with SMTP id 2so1740316pzk.21
        for <linux-wireless@vger.kernel.org>; Fri, 29 Jan 2010 10:08:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1264788131-11671-1-git-send-email-shanyu.zhao@intel.com>
References: <1264788131-11671-1-git-send-email-shanyu.zhao@intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 29 Jan 2010 10:08:06 -0800
Message-ID: <43e72e891001291008n2690c543k6e3cfebb8b45f019@mail.gmail.com>
Subject: Re: [PATCH 1/1] cfg80211: wext: fix cfg80211's SIOCSIWAP function
To: shanyu.zhao@intel.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 29, 2010 at 10:02 AM,  <shanyu.zhao@intel.com> wrote:
> From: Shanyu Zhao <shanyu.zhao@intel.com>
>
> The cfg80211's SIOCSIWAP function is broken, the reason is we cannot
> get the correct bss with previously set ssid. Need to clear it by
> setting ssid_len to 0 in cfg80211_mgd_wext_siwap() and fix other
> places accordingly.

Is this a stable fix as well?

  Luis
