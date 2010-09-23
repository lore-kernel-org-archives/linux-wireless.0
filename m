Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47093 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0IWOxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 10:53:55 -0400
Received: by pvg2 with SMTP id 2so423357pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 07:53:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285231958.3691.10.camel@jlt3.sipsolutions.net>
References: <1285201037-29405-1-git-send-email-lrodriguez@atheros.com>
 <20100923002240.GA4484@tux> <1285231958.3691.10.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 23 Sep 2010 07:53:34 -0700
Message-ID: <AANLkTikh+Q0AK+RyouLOQ5RN5wnKaD2TMnHR-ofqrMKJ@mail.gmail.com>
Subject: Re: [PATCH] wifi-test: add simple roam test script
To: Johannes Berg <johannes@sipsolutions.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "jiajia.zheng@intel.com" <jiajia.zheng@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"wifi-test-devel@lists.sourceforge.net"
	<wifi-test-devel@lists.sourceforge.net>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Paul Stewart <pstew@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 1:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-09-22 at 17:22 -0700, Luis R. Rodriguez wrote:
>
>> After roaming for a good while, this is what I got, not sure
>> yet what caused the NULL pointer dereference... Am I the only
>> one able to reproduce this?
>
>> [ 3276.730081] BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
>> [ 3276.730148] IP: [<0000000000000003>] 0x3
>
> Something called a NULL pointer function pointer. Rafael recently said
> "cpuidle is buggy" when a similar issue came up:
> http://mid.gmane.org/201009182344.12498.rjw@sisk.pl

But that seems related to ACPI, no? On my box I never suspended, I
just associated and disassociated rapidly between two peers. The only
suspicion I have is its obviously right after adding the STA peer.

  Luis
