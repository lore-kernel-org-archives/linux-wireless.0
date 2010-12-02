Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41062 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab0LBUiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 15:38:07 -0500
Received: by iwn42 with SMTP id 42so1352978iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 12:38:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291274908.3481.4.camel@jlt3.sipsolutions.net>
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
 <1291186468.4199.6.camel@jlt3.sipsolutions.net> <1291193337.4199.7.camel@jlt3.sipsolutions.net>
 <201012021623.05381.br1@einfach.org> <1291274908.3481.4.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 2 Dec 2010 12:37:45 -0800
Message-ID: <AANLkTik=Rh=EHxus3y7+FenTY0mCzs-eEy8YUCVhHGKD@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	nbd@openwrt.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 1, 2010 at 11:28 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-12-02 at 16:23 +0900, Bruno Randolf wrote:
>> On Wed December 1 2010 17:48:57 Johannes Berg wrote:
>> > On Wed, 2010-12-01 at 07:54 +0100, Johannes Berg wrote:
>> > > On Wed, 2010-12-01 at 15:47 +0900, Bruno Randolf wrote:
>> > > > Already merged.
>> > > >
>> > > > git show 79b1c460a0b55e55981c25c56597c4d5d2872de3
>> > >
>> > > Oops, sorry -- was on iwlwifi tree which didn't merge yet and got
>> > > confused thinking it was mac80211 only.
>> >
>> > Actually, I take that back. The patch *was* for mac80211 even though it
>> > claimed to be for cfg80211, and you still need to do the cfg80211
>> > versions.
>>
>> Oh, sorry! So many interfaces... ;)
>> Patch on the way...
>
> Thanks!

I wonder if this configuration API will work with this 19 antenna design :-P

http://www.wired.com/epicenter/2010/12/ruckus-wifi-3g/

I think so!

  Luis
