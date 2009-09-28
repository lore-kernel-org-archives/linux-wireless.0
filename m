Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:58556 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbZI1ToP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 15:44:15 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "John W. Linville" <linville@tuxdriver.com>,
	"Florian Fainelli" <florian@openwrt.org>
Cc: ath9k-devel@lists.ath9k.org,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] Makefile ref to non-existent CONFIG_ATHEROS_AR71XX
References: <alpine.LFD.2.00.0909180959550.9988@localhost>
 <200909182004.54398.florian@openwrt.org> <20090928182944.GA4737@tuxdriver.com>
Date: Mon, 28 Sep 2009 21:33:51 +0200
MIME-Version: 1.0
From: "Imre Kaloz" <kaloz@openwrt.org>
Message-ID: <op.u0zfaoao2s3iss@richese>
In-Reply-To: <20090928182944.GA4737@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2009.09.28. 20:29:45 John W. Linville <linville@tuxdriver.com> wrote:

> On Fri, Sep 18, 2009 at 08:04:51PM +0200, Florian Fainelli wrote:
>> Hi Robert,
>>
>> Le vendredi 18 septembre 2009 16:01:25, Robert P. J. Day a écrit :
>> >   searching for Makefile references to Kconfig variables that don't
>> > exist, and i find:
>> >
>> > ===== ATHEROS_AR71XX =====
>> > ./drivers/net/wireless/ath/ath9k/Makefile:ath9k-$(CONFIG_ATHEROS_AR71XX) +=
>> > ahb.o
>>
>> We need it in OpenWrt and plan to send Atheros AR71xx SoC support soon, do not
>> consider this for removal. Thanks
>
> Sure, fine...estimate when it will arrive?
>
> John

When we got access to some more info on the AR7240 so we can finish the support for it.


Imre
