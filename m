Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50798 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab1G3LaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 07:30:13 -0400
Received: by qwk3 with SMTP id 3so2186896qwk.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 04:30:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201107301317.14486.chunkeey@googlemail.com>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <COL114-W54CACDD9B23D044E0916368A370@phx.gbl>
 <CAB=NE6Xc_9DcCz2KfFwR8x2wK5uUt61cH-rP5rNA+-B8XK2gYQ@mail.gmail.com> <201107301317.14486.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 30 Jul 2011 04:29:52 -0700
Message-ID: <CAB=NE6V-=m+S2mkK5ugAfUnBUD_Wvttot6rndC6ToCi8hc2RGw@mail.gmail.com> (sfid-20110730_133022_516663_5C471976)
Subject: Re: problem on ACS
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: MingAnn Ng <devil_eddie01@hotmail.com>, nbd@openwrt.org,
	wireless testing <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 30, 2011 at 4:17 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> Wait a sec... I guess you misunderstood my post about the cut-off.
> I meant that you can cut of at the bottom by using log2(max(1, val)).
> This ensures that the log2 will always be >= 0 anyway. In fact log2(1) = 0.

I get that now, but my point was that we also had to cap it for a
higher value too. We now restrict the input to values within the data
type and also ensure log2 will always be >= 0.

  Luis
