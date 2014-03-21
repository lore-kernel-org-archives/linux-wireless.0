Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f175.google.com ([209.85.128.175]:58855 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758082AbaCUGlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Mar 2014 02:41:18 -0400
Received: by mail-ve0-f175.google.com with SMTP id oz11so2091108veb.20
        for <linux-wireless@vger.kernel.org>; Thu, 20 Mar 2014 23:41:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com>
References: <1395360324-20433-1-git-send-email-greearb@candelatech.com>
	<CA+BoTQn1B6g19Ks41kzcoVyhYbHAcJGTNAyucmPMupbRAy1SNg@mail.gmail.com>
Date: Fri, 21 Mar 2014 14:41:17 +0800
Message-ID: <CAEFj98541uEFjHxjzUeim4nrjELToYrnbJTGuR5WgzwRvF9gkw@mail.gmail.com> (sfid-20140321_074122_111309_E9574D34)
Subject: Re: [PATCH] ath10k: Fix getting stats from firmware.
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Did you test 636 as well? 636 doesn't seem to support more than just `stats_id`.
>
Nope. Tested with 636 not working.

----
Chun-Yeow
