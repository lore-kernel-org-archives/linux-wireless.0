Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64658 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab1HYVXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 17:23:23 -0400
Received: by vxi9 with SMTP id 9so2071926vxi.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 14:23:22 -0700 (PDT)
Message-ID: <4E56BD45.6080308@lwfinger.net> (sfid-20110825_232327_078764_B793B4CA)
Date: Thu, 25 Aug 2011 16:23:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Henry Ptasinski <henryp@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
References: <20110707002034.GA17885@broadcom.com>	<20110824222801.GA5280@broadcom.com> <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
In-Reply-To: <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/25/2011 03:55 PM, Rafał Miłecki wrote:
> 2011/8/25 Henry Ptasinski<henryp@broadcom.com>:
>> With the latest series of cleanup patches merged in by Greg KH, I'd like to
>> once again propose moving brcm80211 out of staging and into mainline.
>
> Henry: a simple question, please explain it to me, what brcmsmac does
> provide that b43 doesn't?
>
> brcmsmac doesn't support SSB and duplicates BCMA support (doesn't make
> use of bcma module)
> brmcsmac doesn't support older PHYs like G/LP
> brmcsmac doesn't support recent HT-PHY
> brmcsmac doesn't support AP or monitor mode
> all of that is supported by b43
>
> The one thing brcmsmac is better at, is support for 14e4:4727 card
> (BCM4313). I've already started work on support of this card in b43,
> hope to get it working soon.
>
>
> You mostly just duplicate support for cards that are already supported by b43.

I am certainly looking forward to the answer to this question.

My %0.02 contribution: When brcmsmac (or its predecessor) first appeared, b43 
supported none of the newest Broadcom hardware. Since then, Rafał has done a 
super job of extending b43, and as he pointed out, the community driver is 
arguably better than the one contributed by Broadcom.

I would like to see the Broadcom engineers concentrate on two things: (1) adding 
their new devices to b43, and (2) try to get their lawyers to allow the 
community to redistribute their firmware. It would also be nice if they opened 
the wl source. I cannot imagine many secrets contained within. Those changes 
would overcome a lot of the bad will that has been built up in the community. 
There are many users that reject a particular model of computer merely because 
it has a Broadcom device included.

Larry
