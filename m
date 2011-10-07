Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52473 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1JGHfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 03:35:46 -0400
Received: by vws1 with SMTP id 1so2891816vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 00:35:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317971874.3988.0.camel@jlt3.sipsolutions.net>
References: <CAFED-j=0-J_H0g3tZoDAX2q8VVFzYfs2n3im07vWkKC_wdh_bA@mail.gmail.com>
	<1317971874.3988.0.camel@jlt3.sipsolutions.net>
Date: Fri, 7 Oct 2011 09:35:45 +0200
Message-ID: <CAFED-jn_FCppQ_=ue-3xCS=v_fyj5+bKkV-do3beGGH9TxpTOA@mail.gmail.com> (sfid-20111007_093555_816691_562D65D7)
Subject: Re: PATCH] mac80211: set no_cck also for hw_scan
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/10/7 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2011-10-07 at 08:56 +0200, Janusz Dziedzic wrote:
>> In case we are using hw_scan we should also
>> send no_cck information to lower layer.
>
>
> Missing Signed-off-by, but I already submitted a very similar patch a
> few days ago.
>

Thanks.

I have a small question also. How should/could I get latest
compat-wireless with git history?
git clone for compat-wireless.git from kernel.org seems not work yet??

In case I have tar ball - eg. compat-wireless-3.0-2.tar.bz2 - how
could I find latest commit for this release?

-- 
Janusz Dziedzic
