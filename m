Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:23026 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763944AbYEOTxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2008 15:53:03 -0400
Received: by ug-out-1314.google.com with SMTP id h2so1461080ugf.16
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2008 12:53:02 -0700 (PDT)
Message-ID: <eb97335b0805151253jeea20b9g91911b825ed8db77@mail.gmail.com> (sfid-20080515_215331_895421_20F72015)
Date: Thu, 15 May 2008 15:53:01 -0400
From: "Zack Weinberg" <zackw@panix.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: Getting ath5k driver working with Thinkpad T61 [168c:1014]
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <40f31dec0805151244o2438c3bfrbbe065ab58a7198@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <eb97335b0805141024w6afa864j860b312b072faa8a@mail.gmail.com>
	 <40f31dec0805151244o2438c3bfrbbe065ab58a7198@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 15, 2008 at 3:44 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> Are you sure that ath5k from compat-wireless is being used and not the
> one that comes with 2.6.25 ?

Yes.

> Have you tried blacklisting ath5k, power-cycle and only use
> madwifi/ndiswrapper ?

Only madwifi, not ndiswrapper.

> If your card doesn't work even after disabling ath5k and power-cycle
> (reboot won't work, you'll have to actually turn your system off and
> on)

Did that.

> then you might have some hw problem.

Doubt it.  It works fine in Windows, after all.

zw
