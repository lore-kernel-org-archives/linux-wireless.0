Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plainfield.sei.cmu.edu ([192.58.107.45]:40864 "EHLO
	plainfield.sei.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbbLPS5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 13:57:45 -0500
From: "Adam R. Welle" <arwelle@cert.org>
To: Bob Copeland <me@bobcopeland.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: question on "mac80211_hwsim: support any address in userspace"
Date: Wed, 16 Dec 2015 18:57:30 +0000
Message-ID: <2DE9F46DD36D2A458CD6347950113F2535C4C2@marathon> (sfid-20151216_195749_413142_CE8BDA62)
References: <5670DA9A.4010102@candelatech.com>
 <1450257464.3159.1.camel@sipsolutions.net>
 <56716386.4070107@candelatech.com>
 <1450272308.8247.11.camel@sipsolutions.net>
 <567168AF.4060804@candelatech.com>
 <1450273362.8247.15.camel@sipsolutions.net>
 <2DE9F46DD36D2A458CD6347950113F2535C1ED@marathon>
 <20151216174602.GG4073@localhost>
In-Reply-To: <20151216174602.GG4073@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > I should note that I am passing these frames between virtual machines
> > so the use of unique addresses (instead of hard-coded 0x42 addresses)
> > as a key simplifies things when determining which radio transmitted a
> > given frame and which radio needs to receive the frame. My app has
> > always relied on the MAC address assigned by the user as a unique key
> > across virtual machines.
> 
> Sounds interesting - is this app open source?

We intend for it to be but I am not sure how long it will take to make that
happen. I told Johannes a few months ago that I was using mac80211_hwsim and
a wmediumd-inspired app to train wireless pen-testing skills. I am using
VMWare as the hypervisor and everything has been working pretty well.
	
Adam

--
