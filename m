Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:20988 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbYHMGlo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 02:41:44 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Pondering: how to improve mac80211 roaming ...
Date: Wed, 13 Aug 2008 08:41:37 +0200
Cc: "Jouni Malinen" <j@w1.fi>, "Helmut Schaa" <hschaa@suse.de>,
	linux-wireless@vger.kernel.org
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <20080812154223.GE4981@jm.kir.nu> <43e72e890808121056ua211e66lbc7bc8d619390bfd@mail.gmail.com>
In-Reply-To: <43e72e890808121056ua211e66lbc7bc8d619390bfd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200808130841.37180.hs4233@mail.mn-solutions.de> (sfid-20080813_084149_580717_A56BCE10)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If someone is picking this up please extend our TODO list for
> roaming and mention it:
>
> http://wireless.kernel.org/en/developers/todo-list#Roaming

Nice tip. From this page, I saw that wpa_supplicant supports 
802.11r (Fast BSS transition: establish security/QoS to an AP 
before making the transition). I assume that mac80211 doesn't 
support this yet?

>From the wikipedia page about this I also found 802.11k (Radio 
Resource management - AP detects that station is moving away, AP 
informs station, Station asks AP for list of stations and uses 
this to select another station). Does anybody know an AP with 
802.11k support?
