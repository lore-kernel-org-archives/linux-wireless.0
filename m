Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:13931 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754074AbYGPMtf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 08:49:35 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3245060waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2008 05:49:34 -0700 (PDT)
Message-ID: <1ba2fa240807160549u68d9ecby25e79d832d772a0a@mail.gmail.com> (sfid-20080716_144939_106039_88F2FE76)
Date: Wed, 16 Jul 2008 15:49:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: pull request: wireless-next-2.6 2008-07-14
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20080714.204532.116542087.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080714192302.GA2541@tuxdriver.com>
	 <20080714.204532.116542087.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 15, 2008 at 6:45 AM, David Miller <davem@davemloft.net> wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Mon, 14 Jul 2008 15:23:02 -0400
>
>> Here is one last(?) round of miscellaneous patches I hope to get into
>> 2.6.27.  There are mostly driver updates, including a sizable iwlwifi
>> set of changes.
>>
>> Please let me know if there are problems!
>
> Pulled into net-next-2.6, thanks John.
>
> If someone could fix the following wireless warnings I'd appreciate
> it.
>
> Thanks!
>

> drivers/net/wireless/iwlwifi/iwl-led.c:271: warning: format '%lld' expects type 'long long int', but argument 6 has type 's64'
> drivers/net/wireless/iwlwifi/iwl-led.c:271: warning: format '%lld' expects type 'long long int', but argument 7 has type 'u64'

I cannot reproduce this. Wasn't this conversion already solved or
still need to cast to long long int?
Tomas
