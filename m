Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:27321 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYGFHHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2008 03:07:45 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1135499waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2008 00:07:42 -0700 (PDT)
Message-ID: <1ba2fa240807060007i572d054va60aa16b41cadce3@mail.gmail.com> (sfid-20080706_090805_397712_40FAB391)
Date: Sun, 6 Jul 2008 10:07:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: pull request: wireless-next-2.6 2008-07-02
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080705.214752.85024966.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080630215651.GA666@tuxdriver.com>
	 <20080702193710.GA4682@tuxdriver.com>
	 <20080702202653.GA10719@tuxdriver.com>
	 <20080705.214752.85024966.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 6, 2008 at 7:47 AM, David Miller <davem@davemloft.net> wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Wed, 2 Jul 2008 16:26:53 -0400
>
>> Here is another slew of updates for 2.6.27.  The bulk of this batch is
>> for iwlwifi, with some mac80211 and other bits thrown-in.
>>
>> Let me know if there are problems!
>
> Pulled and pushed back out to net-next-2.6, thanks.
>
> Here are some warnings I noticed during an allmodconfig build
> on sparc64, please fix:
>
> drivers/net/wireless/hostap/hostap_hw.c:3422: warning: 'prism2_suspend' defined but not used
> drivers/net/wireless/iwlwifi/iwl-rfkill.c:114: warning: label 'freed_rfkill' defined but not used

John what happened to to those patches?
http://marc.info/?l=linux-wireless&m=121489830307988&w=2
http://marc.info/?l=linux-wireless&m=121481826531792&w=2
Thanks
Tomas
