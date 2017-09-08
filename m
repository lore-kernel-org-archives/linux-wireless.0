Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:2541 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755517AbdIHPHr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 11:07:47 -0400
Content-Type: text/plain; charset="utf-8"
Date: Fri, 8 Sep 2017 17:07:42 +0200
In-Reply-To: <1504880360.20347.0.camel@sipsolutions.net>
References: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de> <593fec4f-fc0c-4610-b144-35760ee92102@MAIL1.uni-rostock.de> <1504880360.20347.0.camel@sipsolutions.net>
MIME-Version: 1.0
Subject: Re: [RFC 3/4] mac80211_hwsim: explicitly set netlink parallel ops to false
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Message-ID: <5BB75376-46E0-45F4-8886-C90CEA37CB2B@uni-rostock.de> (sfid-20170908_170801_824257_26E959E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 8=2E September 2017 16:19:20 MESZ schrieb Johannes Berg <johannes@sipso=
lutions=2Enet>:
>On Fri, 2017-09-08 at 16:11 +0200, Benjamin Beichler wrote:
>> The ops field is zero initialized, therefore parallel ops is already
>> false=2E
>
>Therefore this patch is completely pointless?
Sorry my first message was missing regarding this=2E My question is, wheth=
er this is intentionally, and if it is parallel, whether we need extensive =
locking here=2E

>
>johannes

--=20
M=2ESc=2E Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrotec=
hnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin=2EBeichler@uni-rostock=2Ede
www: http://www=2Eimd=2Euni-rostock=2Ede/
