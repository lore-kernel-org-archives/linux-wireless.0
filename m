Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34436 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbcDGOcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 10:32:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Reizer\, Eyal" <eyalr@ti.com>
Cc: Eyal Reizer <eyalreizer@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] wlcore: spi: add wl18xx support
References: <1459343218-24536-1-git-send-email-eyalr@ti.com>
	<87shyx38tz.fsf@purkki.adurom.net>
	<8665E2433BC68541A24DFFCA87B70F5B360B5430@DFRE01.ent.ti.com>
Date: Thu, 07 Apr 2016 17:32:08 +0300
In-Reply-To: <8665E2433BC68541A24DFFCA87B70F5B360B5430@DFRE01.ent.ti.com>
	(Eyal Reizer's message of "Thu, 7 Apr 2016 12:45:13 +0000")
Message-ID: <87wpo97amv.fsf@kamboji.qca.qualcomm.com> (sfid-20160407_163232_689318_8BAF490B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Reizer, Eyal" <eyalr@ti.com> writes:

>> >  static const struct of_device_id wlcore_spi_of_match_table[] = {
>> > -	{ .compatible = "ti,wl1271" },
>> > +	{ .compatible = "ti,wl1271", .data = &wl12xx_data},
>> > +	{ .compatible = "ti,wl1273", .data = &wl12xx_data},
>> > +	{ .compatible = "ti,wl1281", .data = &wl12xx_data},
>> > +	{ .compatible = "ti,wl1283", .data = &wl12xx_data},
>> > +	{ .compatible = "ti,wl1801", .data = &wl18xx_data},
>> > +	{ .compatible = "ti,wl1805", .data = &wl18xx_data},
>> > +	{ .compatible = "ti,wl1807", .data = &wl18xx_data},
>> > +	{ .compatible = "ti,wl1831", .data = &wl18xx_data},
>> > +	{ .compatible = "ti,wl1835", .data = &wl18xx_data},
>> > +	{ .compatible = "ti,wl1837", .data = &wl18xx_data},
>> >  	{ }
>> 
>> Shouldn't you also update bindings/net/wireless/ti,wlcore,spi.txt? Now it only
>> mentions about ti,wl1271 and not anything about the rest.
>
> You are right! Will be fixed in v2

Thanks. Also remember to CC devicetree list.

-- 
Kalle Valo
