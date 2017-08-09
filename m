Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:57152 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753027AbdHIQ7d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 12:59:33 -0400
Date: Wed, 9 Aug 2017 09:59:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [v5] wlcore: add missing nvs file name info for wilink8
Message-ID: <20170809165924.GA3930@atomide.com> (sfid-20170809_185949_277585_448BBCE8)
References: <1502090869-8833-1-git-send-email-eyalr@ti.com>
 <8665E2433BC68541A24DFFCA87B70F5B3641E25B@DFRE01.ent.ti.com>
 <20170807073808.GD5487@atomide.com>
 <8665E2433BC68541A24DFFCA87B70F5B3641E339@DFRE01.ent.ti.com>
 <20170808042054.GI5190@atomide.com>
 <8665E2433BC68541A24DFFCA87B70F5B36420D9E@DFRE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B36420D9E@DFRE01.ent.ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [170809 00:26]:
> Managed to test with a wilink6 module and in fact reading hardware mac
> Address from fuse is working ok for wilink6/7 as well.
> submitting v6 using this mac address instead of a random one when the 
> bogus (deadbeef...) mac address is read from default nvs file.

Hey great, that should help clear quite a bit of the wl12xx confusion
with distros! Thanks for doing that.

Regards,

Tony
