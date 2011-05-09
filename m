Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47165 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab1EIW6L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 18:58:11 -0400
Message-ID: <4DC8717C.70405@candelatech.com> (sfid-20110510_005814_654381_57327EDD)
Date: Mon, 09 May 2011 15:58:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless@vger.kernel.org,
	Juan Carlos Romero <juancarlos.romero@gmail.com>
Subject: Re: Regression affecting b43 LP-PHY card
References: <BANLkTin=cU_kCSFfznna69pkgTsSNVjJgw@mail.gmail.com>
In-Reply-To: <BANLkTin=cU_kCSFfznna69pkgTsSNVjJgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/09/2011 03:52 PM, Rafał Miłecki wrote:

> Did anyone else experience any similar problems with latest wireless-testing?

With the ath5k patch I posted, and the ath9k patches that Felix
posted recently in response to my bug reports, I've had good
luck with ath9k and ath5k.

I also pulled in the slub cmpxcg fix that fixes fatal bugs
for compiles for something earlier than Pentium-II processors.

Hopefully -rc7 will be out shortly (which will contain the slub
fix, and if we're lucky..the ath9k and ath5k fixes too).

I don't test with any other wifi nics..just ath5k and ath9k.

I've mostly been testing virtual stations...will crank up some
ath9k APs shortly...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

