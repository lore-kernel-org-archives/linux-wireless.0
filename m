Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34682 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbbH3Rn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2015 13:43:29 -0400
Received: by oiex83 with SMTP id x83so53733577oie.1
        for <linux-wireless@vger.kernel.org>; Sun, 30 Aug 2015 10:43:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150829222531.GA8604@localhost>
References: <1440673024-13696-1-git-send-email-me@bobcopeland.com>
	<1440673024-13696-4-git-send-email-me@bobcopeland.com>
	<CAKf6xpsaygeFJyX_LKH2r82P2Xvih1GGBTAspKtCsZbBcVO9Ug@mail.gmail.com>
	<20150829222531.GA8604@localhost>
Date: Mon, 31 Aug 2015 01:43:28 +0800
Message-ID: <CAEFj987gvasYnRq8tiFeQitbBmoXAr77hXU2cUW_TsH+viUn8g@mail.gmail.com> (sfid-20150830_194333_659814_BD49353B)
Subject: Re: [PATCH 3/3] ath10k: implement mesh support
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jason Andryuk <jandryuk@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Bob

> Yes: you don't want to enable raw mode TX / RX decap in the normal
> case because it's fairly inefficient compared to "native" wifi mode,
> according to my understanding.  The latter doesn't support mesh framing
> however.
>

The native WiFi mode doesn't support mesh framing. Can you elaborate
more on this?

Thanks

----
Chun-Yeow
