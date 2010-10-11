Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60146 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab0JKQgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 12:36:31 -0400
Received: by qyk10 with SMTP id 10so4488034qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Oct 2010 09:36:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik1JPNaDKrS8ST_Lt+iEg21-rcetVTSnYmx-qW3@mail.gmail.com>
References: <1286810435-10820-1-git-send-email-zajec5@gmail.com>
	<1286810435-10820-3-git-send-email-zajec5@gmail.com>
	<AANLkTik1JPNaDKrS8ST_Lt+iEg21-rcetVTSnYmx-qW3@mail.gmail.com>
Date: Mon, 11 Oct 2010 18:36:30 +0200
Message-ID: <AANLkTingK+o8viDgMdV+jq7kLduda_W=cFr_n08g4V1L@mail.gmail.com>
Subject: Re: [PATCH 3/3] b43: N-PHY: add 2055 radio regs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 11 października 2010 18:24 użytkownik Gábor Stefanik
<netrolller.3d@gmail.com> napisał:
> Doesn't brcm80211 contain register names for B2055?

Whoops... first of all it's 2056 radio. Commit's message should be
2056, not 2055.

Yes, I'm sure we can grab many defines from brcm80211. However before
copying their code/defines I wanted to finish implementing what we
have in our RE specs. Is that acceptable? Or should I use brcm80211's
names if I already touch such places?

-- 
Rafał
