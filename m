Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:52400 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab1H3J3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:29:10 -0400
Date: Tue, 30 Aug 2011 11:28:54 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Greg KH <gregkh@suse.de>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dan Carpenter <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110830112854.58a74f81@milhouse> (sfid-20110830_112915_195814_C0B016E2)
In-Reply-To: <CACna6rzpce7x9cOAEbB04jTuawze5fG6cL1usNy79Yc-zExFwg@mail.gmail.com>
References: <20110707002034.GA17885@broadcom.com>
	<20110824222801.GA5280@broadcom.com>
	<CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
	<20110827143513.GN3775@shale.localdomain>
	<20110827145003.GA9405@suse.de>
	<CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
	<20110827152144.GA10126@suse.de>
	<20110830014257.GI15771@broadcom.com>
	<20110830042802.GA15320@suse.de>
	<1314685349.4011.17.camel@jlt3.sipsolutions.net>
	<CACna6rzpce7x9cOAEbB04jTuawze5fG6cL1usNy79Yc-zExFwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 30 Aug 2011 10:31:08 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> I got lost. You're talking a lot about ucode, but I don't know what do
> you really mean. Do you have some additional info from Broadcom? Are
> they going to release some new ucode not compatible with some older
> cards?

They do so frequently and always did this.
The problem in b43 is, that b43 needs to support _all_ ucode
APIs from 5 to x (Dunno where we are right now. somewhere > 15).
That was relatively easy until now, because the API didn't vary a lot
between cores. I don't know what will/did change for latest wireless
features, though. But you already applied some changes to the affecting
code. I don't know how complete that stuff is.

-- 
Greetings, Michael.
