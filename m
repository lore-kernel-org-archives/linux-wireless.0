Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:62923 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbZHMDds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 23:33:48 -0400
Received: by yxe5 with SMTP id 5so658485yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 20:33:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b6c5339f0908121408q4f3382e3rabd4def2de14c56c@mail.gmail.com>
References: <1250096290-11058-1-git-send-email-lrodriguez@atheros.com>
	<4A83064A.2080609@gmail.com> <43e72e890908121148l2cde20a9xb2c045e03574ffaa@mail.gmail.com>
	<b6c5339f0908121408q4f3382e3rabd4def2de14c56c@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 12 Aug 2009 20:33:29 -0700
Message-ID: <43e72e890908122033g436597ecta275c32ed3a7815d@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH] ath5k: fix requested allocated RX skb size
	for DMA
To: Bob Copeland <me@bobcopeland.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org, Nick Kossifidis <mickflemm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John please ignore this patch, its busted, as Bob noted on IRC.

  Luis
