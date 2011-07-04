Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47152 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab1GDJst (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 05:48:49 -0400
Received: by gyh3 with SMTP id 3so1889672gyh.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 02:48:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
Date: Mon, 4 Jul 2011 12:48:48 +0300
Message-ID: <CAFtRNNzEUZ7LfgQ=XQjrjtj382puuaJhx=mHnFJhjt0Act6o_Q@mail.gmail.com> (sfid-20110704_114853_092100_360163CC)
Subject: Re: [PATCH 1/8] ath5k: add missing checks for rfgain probe
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/4 Felix Fietkau <nbd@openwrt.org>:
> rfgain probe is only necessary for OFDM operation on AR5112 and no other
> radio chips
>

It's also available on RF5111 (with AR5211 or AR5212)...

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
