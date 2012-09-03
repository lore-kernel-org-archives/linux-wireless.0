Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40899 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab2ICOBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 10:01:34 -0400
Received: by obbuo13 with SMTP id uo13so9166682obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2012 07:01:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn2CYYP2+VRX0Ph=6Vw2kTqmwRvMn+FVeS3FwMd=jvwy8Q@mail.gmail.com>
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
	<CAD2nsn16-uZ0CbBXrHjUS2Rwn53OYNrLvjujmPAwGDCEbdYJxg@mail.gmail.com>
	<20120827065419.GB22073@ritirata.org>
	<CAD2nsn2CYYP2+VRX0Ph=6Vw2kTqmwRvMn+FVeS3FwMd=jvwy8Q@mail.gmail.com>
Date: Mon, 3 Sep 2012 19:31:34 +0530
Message-ID: <CAD2nsn3Q5tCp1ENsT=subp4u1GE6jazSGB=trnb6MjR8AR6m=w@mail.gmail.com> (sfid-20120903_160138_266909_D52D8D7A)
Subject: Re: [PATCHv2 1/2] ath9k_htc: remove driver specific checks for
 interfaces combinations
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Antonio,

>> Other than that, patch 2/6 should be modified to take into account IBSS mode.
>
> yeah saw your patch, that in ath9k_htc IBSS interface can coexist with
> one more interface.

sorry for the delayed response(almost tortoise's pace :) ), the
ath9k_htc maintainer said
TSF sync may be an issue if we have IBSS interface coexistence, any
thoughts about this (or)
this should be fine based on your testing. please let me know!

-- 
thanks,
shafi
