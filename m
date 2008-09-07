Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:39960 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbYIGOYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 10:24:40 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1179103fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 07 Sep 2008 07:24:38 -0700 (PDT)
Message-ID: <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com> (sfid-20080907_162445_422946_850CF724)
Date: Sun, 7 Sep 2008 17:24:38 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1220794765.31304.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 7, 2008 at 4:39 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2008-09-07 at 01:14 +0300, Tomas Winkler wrote:
>> This series should fix mac problems in disassociation
>> There are two basic problems disassociation in current implementation.
>> The order of steps in the dissociation flow and missing proper
>> disassociation when moving from one AP to another.
>
> Mind if I adopt this patch series? I've done only slight modifications
> so far (the int->bool thing I asked for) and have rebased all the
> patches I had already posted on top of it. The arguments to
> ieee80211_set_disassoc are changing a lot in my patch series anyway so
> I'll just work on top of the bool/bool thing and  then fix it up, ok?

Don't mind just need to test them properly and update commit messages.
Any suggestion how we do that?
Tomas
