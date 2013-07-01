Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:45613 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471Ab3GAOrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 10:47:53 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: =?utf-8?B?0KDQvtC80LDQvSDQkC4gYWthIEJhc2ljWFA=?= <x12ozmouse@ya.ru>
Cc: "wireless-regdb\@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Subject: [wireless-regdb] What about 80 and 160 MHz channels? (was: Update regulatory rules for Russia (RU) on 5GHz)
References: <6F6BB55A-0E6F-4067-A1CE-4B7A77FD51BD@ya.ru>
	<26561339160385@web1g.yandex.ru>
Date: Mon, 01 Jul 2013 16:47:22 +0200
In-Reply-To: <26561339160385@web1g.yandex.ru> (=?utf-8?B?ItCg0L7QvNCw0L0g?=
 =?utf-8?B?0JAu?= aka BasicXP"'s
	message of "Fri, 08 Jun 2012 16:59:45 +0400")
Message-ID: <877gha2v7p.fsf_-_@nemi.mork.no> (sfid-20130701_164759_556745_CFD62F44)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Роман А. aka BasicXP <x12ozmouse@ya.ru> writes:

> Please abort, the info seems to be outdated.
>  
>
>      
>     Please update the regulatory rules for Russia (RU) on 5GHz to be the following:
>    
>         (5170 - 5350 @ 40), (N/A, 20)
>         (5650 - 5835 @ 40), (N/A, 30)
>    
>     i.e. channels 34-64 can be used in either 20MHz or 40MHz modes
>     with maximum power of 20dBm (-10 dBW), and channels 132-165 can be
>     used in either 20MHz or 40MHz modes with maximum power of 30dBm (0
>     dBW).
>    
>     Information is taken from the official document available
>     here: http://www.rfs-rf.ru/idc/groups/public/documents/grhc_native_files/005571.doc

Which doesn't seem to restrict the channel width, does it?  802.11ac
cards and APs are on the market.  I wonder if it is time to start
changing all those unnecessary 40 MHz limits?

At least for Europe, the norm seems to be limits on total power and
power density within the allowed bands, but no actual channel width
restrictions.  Any channel is OK as long as the you stay within the
other limits.

Or do I misread the regulations?

Using 802.11ac 80MHz channels *anywhere* seems to require overriding the
regdb at the moment, which can't be right?  Googling leads to some
patches like this one:
http://lists.infradead.org/pipermail/wireless-regdb/2013-April/000153.html
but nothing which has been applied.

Given that most of the current 40 MHz restrictions are just invented to
fit into the database, isn't a bulk update appropriate?


Bjørn
