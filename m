Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 12.mo3.mail-out.ovh.net ([188.165.41.191]:39864 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228AbaIXW12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2014 18:27:28 -0400
Received: from mail638.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo3.mail-out.ovh.net (Postfix) with SMTP id D7C5AFF960D
	for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2014 20:49:37 +0200 (CEST)
Message-ID: <5423123C.5000607@ventoso.org> (sfid-20140925_002731_760117_058F8C5F)
Date: Wed, 24 Sep 2014 20:49:32 +0200
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Mediatek MT7601U big endian fixes
References: <5422FD0B.3060806@ventoso.org> <20140924175135.GB31690@tuxdriver.com>
In-Reply-To: <20140924175135.GB31690@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El 24/09/14 19:51, John W. Linville ha escrit:

>> Do you know if is there somebody (at ralink/mediatek or elsewhere)
>> working on integrating this chipset in the in-kernel driver?
>>
>> Bye
>> -- 
>> Luca
> 
> I don't know of anyone from Ralink/MediaTek or otherwise working
> on that.  I sent some emails to MediaTek on this issue recently,
> but I made the mistake of including someone from the community who
> actively undermind my attempts to reach-out to MediaTek...

Oh, that's bad. It's not that the driver doesn't work (it does, once
patched), but it doesn't integrate nicely (i.e. no mac80211 support).

> If you (or anyone else) want to work on integrating device support
> from that driver with the in-kernel drivers then I encourage you to
> do so. 

Unfortunately, I'm not the right person for the job :-(
That's why I asked.

> If you happen to have better contacts with MediaTek than I
> have, then please feel free to reach out to them and/or to put them
> in contact with me.

I don't know anybody at Mediatek, I just contacted them about the issue
through their web form. I didn't think I could fix it by myself. In
fact, I still don't understand why it's necessary to  byte swap
structures that are already defined differently for big endian/little
endian, see the point above about me not being the right person for the
job ;-)


Bye
-- 
Luca
