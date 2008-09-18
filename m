Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:28280 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYIRSmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:42:49 -0400
Received: by yx-out-2324.google.com with SMTP id 8so10451yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 11:42:48 -0700 (PDT)
Message-ID: <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com> (sfid-20080918_204252_665197_EE5E1564)
Date: Thu, 18 Sep 2008 11:42:48 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
In-Reply-To: <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f488382f0809181123n55a4979eg1996bbc30fa47d54@mail.gmail.com>
	 <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 11:34 AM, Luis R. Rodriguez
> irqpoll is a monster of evil and that should make your system crawl to
> its knees. I would advise instead we work with you fixing the the
> missed interrupts issue upon rmmod.

Also, please provide the output of

cat /proc/interrupts

and also please do not cross post to all these lists, just use
linux-wireless or ath9k.

  Luis
