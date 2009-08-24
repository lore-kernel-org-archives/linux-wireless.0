Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:57499 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbZHXSV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 14:21:58 -0400
Received: by iwn42 with SMTP id 42so1035240iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 11:22:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250847779.17888.5.camel@johannes.local>
References: <43e72e890908171804t2279c750j7baeaf37ad4ff205@mail.gmail.com>
	<1250847779.17888.5.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 24 Aug 2009 11:21:40 -0700
Message-ID: <43e72e890908241121j43683b75x38ef7c2ef3a71463@mail.gmail.com>
Subject: Re: Few warnings from master-2009-08-17
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 21, 2009 at 2:42 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Mon, 2009-08-17 at 18:04 -0700, Luis R. Rodriguez wrote:
>
>> Aug 17 17:45:50 tux kernel: [  424.812910] ------------[ cut here ]------------
>> Aug 17 17:45:50 tux kernel: [  424.812928] WARNING: at
>> net/wireless/sme.c:610 __cfg80211_disconnected+0x1fb/0x260
>> [cfg80211]()
>> Aug 17 17:45:50 tux kernel: [  424.812931] Hardware name: 7660A14
>> Aug 17 17:45:50 tux kernel: [  424.812933] deauth failed: -67
>
> what was before that?

[ 1058.261102] No probe response from AP <AP-mac-address> after 500ms, try 1
[ 1058.761100] No probe response from AP <AP-mac-address> after 500ms, try 2
[ 1059.261122] No probe response from AP <AP-mac-address> after 500ms, try 3
[ 1059.761105] No probe response from AP <AP-mac-address> after 500ms, try 4
[ 1060.261105] No probe response from AP <AP-mac-address> after 500ms,
disconnecting.
[ 1060.264257] phy1: device now idle
[ 1060.268293] phy1: Removed STA <AP-mac-address>
[ 1060.290788] phy1: Destroyed STA <AP-mac-address>
[ 1060.290961] wlan6: deauthenticating by local choice (reason=3)

  Luis
