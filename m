Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36456 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab3JaQmw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Oct 2013 12:42:52 -0400
Received: by mail-lb0-f171.google.com with SMTP id x18so2578354lbi.2
        for <linux-wireless@vger.kernel.org>; Thu, 31 Oct 2013 09:42:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383237294.14302.5.camel@jlt4.sipsolutions.net>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com> <1383237294.14302.5.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 31 Oct 2013 17:42:30 +0100
Message-ID: <CAB=NE6VZSZ0Et0Y8girRSRO9-hd2H-SfnihwJC60wKfzv70PFw@mail.gmail.com> (sfid-20131031_174256_869771_5F51A682)
Subject: Re: [PATCH 00/14] wlan: consolidate passive-scan and no-ibss flags
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"Shete, Mihir" <smihir@qti.qualcomm.com>,
	"Bhattacharyya, Tushnim" <tushnimb@qca.qualcomm.com>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 31, 2013 at 5:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-10-21 at 19:22 +0200, Luis R. Rodriguez wrote:
>> John, Johannes,
>>
>> This series addresses consolidating passive-scan and no-ibss flags.
>> Since its crosses over drivers I'll let you guys decide what tree
>> this goes into.
>
> Alright, I've applied this, but in one single big patch, and I've redone
> (most of) the driver updates using spatch.
>
> There were conflicts applying the patch, so most likely John will get
> conflicts when merging my tree. I've added the spatches to the commit
> log so that should be easy to resolve.

Oh I love to hear merge conflict issues are being addressed with
Coccinelle, thanks for the update. I should have just provided the
SmPL for it in the first place ;) -- my bad.

  Luis
