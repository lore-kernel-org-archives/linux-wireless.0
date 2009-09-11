Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:33788 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbZIKGUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Sep 2009 02:20:25 -0400
Received: by ewy2 with SMTP id 2so804950ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 23:20:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252611027-5285-7-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
	 <1252611027-5285-7-git-send-email-lrodriguez@atheros.com>
Date: Fri, 11 Sep 2009 09:20:26 +0300
Message-ID: <40f31dec0909102320l23b1350sfdb9eb3c066c235b@mail.gmail.com>
Subject: Re: [PATCH 06/10] ath5k: use common curbssid, bssidmask and macaddr
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, devel@linuxdriverproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/9/10 Luis R. Rodriguez <lrodriguez@atheros.com>:
>
> -
> -/****************\
> -* BSSID handling *
> -\****************/
> -

No need to remove that unless all bssid related functions are gone.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
