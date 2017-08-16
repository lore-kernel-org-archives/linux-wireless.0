Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56596 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751461AbdHPN5w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 09:57:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Reizer\, Eyal" <eyalr@ti.com>
Cc: Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        "\,Tony Lindgren" <tony@atomide.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [v7 wlcore: add missing nvs file name info for wilink8
References: <8665E2433BC68541A24DFFCA87B70F5B36425E3C@DFRE01.ent.ti.com>
        <20170815130952.bknron5yuqsdlazb@earth>
        <8665E2433BC68541A24DFFCA87B70F5B36427AC2@DFRE01.ent.ti.com>
Date: Wed, 16 Aug 2017 16:57:45 +0300
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B36427AC2@DFRE01.ent.ti.com>
        (Eyal Reizer's message of "Wed, 16 Aug 2017 07:17:53 +0000")
Message-ID: <87y3qj7gyu.fsf@kamboji.qca.qualcomm.com> (sfid-20170816_155828_660709_7E521028)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> writes:

>> > +		if (wl->fuse_oui_addr == 0 && wl->fuse_nic_addr == 0) {
>> > +			wl1271_warning("Fuse mac address is zero. using "
>> > +					"random mac\n");
>> 
>> This one should also go into one line.
>
> This will still exceed 80 characters. Is this still ok?

Yes, it's ok that the _format string_ goes above 80 chars, but if there
are paremeters you should split them to a separate line. Example:

	pr_debug("This is an example of a very long message which also prints few variables foo %d bar %d",
		 foo, bar);

-- 
Kalle Valo
