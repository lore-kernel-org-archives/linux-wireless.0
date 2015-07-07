Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:37607 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757AbbGGJjB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 05:39:01 -0400
Received: from localhost (localhost [127.0.0.1])
	by arrakis.dune.hu (Postfix) with ESMTP id 26CD328BDCC
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2015 11:38:42 +0200 (CEST)
Received: from mail-qg0-f41.google.com (mail-qg0-f41.google.com [209.85.192.41])
	by arrakis.dune.hu (Postfix) with ESMTPSA id 9A20F28BE45
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2015 11:38:35 +0200 (CEST)
Received: by qgii30 with SMTP id i30so81432407qgi.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2015 02:38:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e90aaab05cfd43fe9c05f738d4fc528a@SC-EXCH02.marvell.com>
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
 <CAOiHx=ncv=N33-CC-F0=_dovJ=PGsi3MBB3SEMg51fWcyuMmPg@mail.gmail.com> <e90aaab05cfd43fe9c05f738d4fc528a@SC-EXCH02.marvell.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Tue, 7 Jul 2015 11:38:32 +0200
Message-ID: <CAOiHx=nnzfURJk6qeoyaV_qX0HPdtKSvZNmSNxKxypURMpNbkA@mail.gmail.com> (sfid-20150707_113907_665449_A4D6E2DD)
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 7, 2015 at 3:47 AM, David Lin <dlin@marvell.com> wrote:
>>Jonas Gorski wrote:
>>
>> Hi,
>>
>> On Fri, Jul 3, 2015 at 8:10 AM, David Lin <dlin@marvell.com> wrote:

(snip)

>> > diff --git a/drivers/net/wireless/mwlwifi/Kconfig
>> > b/drivers/net/wireless/mwlwifi/Kconfig
>> > new file mode 100644
>> > index 0000000..3732223
>> > --- /dev/null
>> > +++ b/drivers/net/wireless/mwlwifi/Kconfig
>> > @@ -0,0 +1,24 @@
>> > +config MWLWIFI
>> > +       tristate "Marvell Wireless Wi-Fi driver (mwlwifi)"
>>
>> Do you also have wired Wi-Fi cards? ;P
>>
>> The description seems very generic despite only supporting two chips.
>> Currently we already have two other marvell drivers claiming to support
>> "marvell" wireless:
>>
>> config MWL8K
>>         tristate "Marvell 88W8xxx PCI/PCIe Wireless support"
>>
>> config MWIFIEX
>>         tristate "Marvell WiFi-Ex Driver"
>>
>> I think it would be good to have some more precise description here
>> (something like "Marvell 88W8864/8897 PCIe driver with AP support").
>>
>
> Will change the title from "Marvell Wireless Wi-Fi driver (mwlwifi)" to "Marvell 88W8864/88W8897 PCIe driver with AP support".

As Imre pointed out, mwifiex also supports AP mode, so this is not a
good description.


Jonas
