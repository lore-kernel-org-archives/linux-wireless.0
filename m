Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61348 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379Ab0LJQUd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 11:20:33 -0500
Received: by yxt3 with SMTP id 3so2157612yxt.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 08:20:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikFnb=ErjA0VeS6oekExHxT1-Mh5_wa28UqEZZ4@mail.gmail.com>
References: <AANLkTim5HQGNL-vSapeQw_-dJue89pYz7zc8eiShma8j@mail.gmail.com> <AANLkTikFnb=ErjA0VeS6oekExHxT1-Mh5_wa28UqEZZ4@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Dec 2010 08:20:12 -0800
Message-ID: <AANLkTi=T_oGkRowjaoPAhSMFGNeiioji8RdtdrdJqLv4@mail.gmail.com>
Subject: Re: compat-wireless-2.6.37-rc5 released
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 9, 2010 at 5:08 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>> 01-ath9k-OTP.patch
>> 03-ath9k-no-aggr-VO.patch
>> 04-mac80211-no-aggr-VO.patch

>> 05-ath9k-Reintroduce-modparam-to-enable-btcoex.patch

I'll skip this one, better synch the modparam with a kernel release
rather than an update like compat-wireless.

>> 06-ath9k_hw-fix-A-MPDU-key-search-issues-on-AR9003.patch

I'm going to start sucking the reset in for a compat-wireless-2.6.37
release. Please let me know if you believe any other patches are
worthy, even if they are for other drivers, etc.

  Luis
