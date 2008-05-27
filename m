Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:64252 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYE0HmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 03:42:15 -0400
Received: by rv-out-0506.google.com with SMTP id l9so2807043rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2008 00:42:15 -0700 (PDT)
Message-ID: <c85cb4470805270042s2cd7f103xdbfffaf318baff89@mail.gmail.com> (sfid-20080527_094219_307792_D153364F)
Date: Tue, 27 May 2008 10:42:15 +0300
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH 1/1] mac80211: fix deadlock in sta->lock
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240805262223u4f884d16g5883dd6c7ba9c670@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211810958-23095-1-git-send-email-tomas.winkler@intel.com>
	 <1211811554.4843.4.camel@johannes.berg>
	 <1ba2fa240805262223u4f884d16g5883dd6c7ba9c670@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> This patch is wrong, it breaks error path.locking.Will resubmit
> Tomas
>

agree, the error path should be fixed, thanks.
