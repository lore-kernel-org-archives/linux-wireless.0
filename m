Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:15417 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYDOIjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 04:39:52 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: AR5K_INT_SWBA can't generate interruption for sending beacons
Date: Tue, 15 Apr 2008 10:36:55 +0200
Cc: "cao jing" <caojing.china@gmail.com>
References: <9f33c5230804142124g3c8f4a0ai28a6b5117e1034c9@mail.gmail.com>
In-Reply-To: <9f33c5230804142124g3c8f4a0ai28a6b5117e1034c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200804151036.55216.hs4233@mail.mn-solutions.de> (sfid-20080415_093955_759199_4F22338B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hi,
>
> I'm working on mac80211 and ath5k. I found that the
> AR5K_INT_SWBA interruption can't be generated. So I can't send
> beacons by this interruption. Anyone knows what's going on
> with it?
>
> Thank you very much!

ath5k didn't make it yet to wireless-testing. That is the git 
tree for all wireless stuff that finally will make it into 
mainline Linux. See http://linuxwireless.org for more detail.

I know that some people from the the OpenMoko work with ATH5K, 
but so far none of the people that work with ATH5K bothered to 
submit the driver have submitted the driver or asked for 
review/inclusion. Therefore I fear that the work development 
force isn't united, but scattered here ...


Also, because ath5k didn't make it into wireless-testing yet, you 
might not find people that know the device well enought here.
