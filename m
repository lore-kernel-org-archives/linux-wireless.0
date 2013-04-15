Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:58547 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751717Ab3DOKar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 06:30:47 -0400
Received: by mail-oa0-f50.google.com with SMTP id n1so4284491oag.9
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 03:30:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKUzqopKB5h-NFoEPkMqakk5_90T8RYn5JVeF64GK76t15n2dQ@mail.gmail.com>
References: <CAKUzqopKB5h-NFoEPkMqakk5_90T8RYn5JVeF64GK76t15n2dQ@mail.gmail.com>
Date: Mon, 15 Apr 2013 12:30:47 +0200
Message-ID: <CACna6rwmwTE9e_kj=BFb54g8R=YzfcpQYE8eYdLS_xedg+wTxA@mail.gmail.com> (sfid-20130415_123051_431005_8A08413C)
Subject: Re:
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Callum Hutchinson <callumhutchinson1@gmail.com>
Cc: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/4/12 Callum Hutchinson <callumhutchinson1@gmail.com>:
> Tried to report this properly via email but got some formatting issues
> coming back, I've attached the content of the original email report as
> 'Report.txt'.
>
> It is the same file as found on comment 12 on Launchpad bug.
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1142385
>
> Apologies for any missing information or lack of reporting experience :)

Sending e-mail with empty subject and without direct information about
the hardware isn't a good idea.

It's most probably another result of regression I've tracked and reported in:
Scanning regression since "cfg80211: use DS or HT operation IEs to
determine BSS channel"

http://www.spinics.net/lists/linux-wireless/msg105359.html
http://marc.info/?t=136431795000003&r=1&w=4

I didn't have enough time to debug it further and fix yet.

-- 
Rafał
