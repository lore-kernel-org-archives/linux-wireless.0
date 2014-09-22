Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:39735 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaIVMuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 08:50:37 -0400
Received: by mail-vc0-f170.google.com with SMTP id ij19so1697638vcb.29
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2014 05:50:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140922110016.GA302@localhost>
References: <1411195244-9130-1-git-send-email-yeohchunyeow@gmail.com>
	<20140922110016.GA302@localhost>
Date: Mon, 22 Sep 2014 20:50:36 +0800
Message-ID: <CAEFj987rTruye3aVYaPKQHp_p99VyTtZbYnMecV_fPNH5g4hQA@mail.gmail.com> (sfid-20140922_145040_551862_7B7CE52E)
Subject: Re: [PATCH v3 1/2] iw: Allow user to provide freq during mesh join
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ashok Nagarajan <ashok.dragon@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2014 at 7:00 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sat, Sep 20, 2014 at 02:40:43PM +0800, Chun-Yeow Yeoh via Devel wrote:
>> +     /* freq */
>> +     if (argc > 1 && strcmp(argv[0], "freq") == 0) {
>> +             argv++;
>> +             argc--;
>
> [snip]
>
>> -COMMAND(mesh, join, "<mesh ID> [mcast-rate <rate in Mbps>]"
>> +COMMAND(mesh, join, "<mesh ID> [freq in MHz] [HT20|HT40+|HT40-|NOHT]"
>
> Should this be something like:
>
>> +COMMAND(mesh, join, "<mesh ID> [freq <freq in MHz> <HT20|HT40+|HT40-|NOHT>]"
>
> ...so we know to specify the 'freq' keyword?

Yes, it makes sense. I will resubmit v4 later on.

----
Chun-Yeow
