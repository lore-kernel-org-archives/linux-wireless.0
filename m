Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:19660 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233AbXHURjs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 13:39:48 -0400
Received: by wr-out-0506.google.com with SMTP id 36so1241100wra
        for <linux-wireless@vger.kernel.org>; Tue, 21 Aug 2007 10:39:46 -0700 (PDT)
Message-ID: <43e72e890708211039y53e2c24aqbf5c00c24f0a0df6@mail.gmail.com>
Date: Tue, 21 Aug 2007 13:39:46 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mark islsm list as subscribers-only
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Michael Wu" <flamingice@sourmilk.net>
In-Reply-To: <1187714252.4218.9.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1187282653.23489.36.camel@johannes.berg>
	 <43e72e890708210932j7684d6c4h8dfe0193f67f1e8f@mail.gmail.com>
	 <1187714252.4218.9.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/21/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2007-08-21 at 12:32 -0400, Luis R. Rodriguez wrote:
>
> > I think that list was for the net80211 driver, not even sure if its
> > used actively for the mac80211 driver.
>
> I'm fine with removing it completely, but having a list listed that
> simply drops your mail (not without spamming you, of course) is just not
> useful.

ACK -- we can create a new list too which we are sure is for p54. Michael?

  Luis
