Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:48511 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYLTTKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 14:10:21 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1108354rnd.17
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 11:10:19 -0800 (PST)
Message-ID: <43e72e890812201110s626d98d9xb82b957c5530c955@mail.gmail.com> (sfid-20081220_201040_641663_EA822294)
Date: Sat, 20 Dec 2008 11:10:19 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Subject: Re: [PATCH 00/16] ath9k: first series for regulatory cleanup
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
In-Reply-To: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 9:55 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

> This should not have any major functional changes, its mostly
> cleanup stuff. I've tested HT20 on 2 GHz, will test 5 GHz tomorrow
> with the HT20/HT40 configurations but I figured I'll get this out
> today. If someone beats me to testing 5 GHz HT20/HT40 configs me
> please let me know.

OK I've tested 5 GHz 802.11a, and 11NAHT40MINUS and found no
regressions. My AP didn't like to set itself to 11NAHT40PLUS but I
think that should be OK.

  Luis
