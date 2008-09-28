Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:48818 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbYI1CtI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 22:49:08 -0400
Received: by ey-out-2122.google.com with SMTP id 6so441729eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 27 Sep 2008 19:49:06 -0700 (PDT)
Message-ID: <f488382f0809271949j3c39a1aag8a57b1cb03a5c001@mail.gmail.com> (sfid-20080928_044926_787569_C581FE07)
Date: Sat, 27 Sep 2008 19:49:06 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC V3] mac80211: re-enable aggregation on 2.6.27
Cc: "Tomas Winkler" <tomas.winkler@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"yi.zhu@intel.com" <yi.zhu@intel.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <f488382f0809251945u3eb1f0bdgfe8587e8c103b009@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222371297-24498-1-git-send-email-tomas.winkler@intel.com>
	 <f488382f0809251243x472ff579n8ada22e8f7110aae@mail.gmail.com>
	 <20080926015100.GR6204@tesla>
	 <f488382f0809251945u3eb1f0bdgfe8587e8c103b009@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 7:45 PM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Thu, Sep 25, 2008 at 6:51 PM, Luis R. Rodriguez <lrodriguez@atheros.com> wrote:
>>
>> Please test and let us know, try HT40 on 11a. We're keen on resolving
>> this just as with the MIB interrupt issue you say ;)
>
> Will do. It will have to wait until Monday though, because I stupidly
> left my AirPort Extreme router's AC adapter at home (3 hours away).

I just realized I happened to have a Linksys WRT300N router with me
(completely forgot I even owned one). Anyway, I'm running with HT40,
and it seems to work fine. Throughput is certainly lower than on Mac
OS X (I get about 8 megabytes per second sustained transfer rate on OS
X), as I'm only getting about 2 megabytes per second with ath9k on
Linux.  The aggregation patch does make a difference, but not by a
whole lot.

- Steven
