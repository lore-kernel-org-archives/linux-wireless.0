Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55551 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab3FFLsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 07:48:33 -0400
Received: by mail-ie0-f170.google.com with SMTP id e14so6797992iej.15
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jun 2013 04:48:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51AF6F5D.5020400@rempel-privat.de>
References: <51ADBC01.6090202@blackshift.org>
	<1370371064-6903-1-git-send-email-linux@rempel-privat.de>
	<CAGXE3d9p7zkwfNJBJvPMc8XaKnb009pHpCXYweDjK4tv6PCkuA@mail.gmail.com>
	<51AF4AA7.6050005@blackshift.org>
	<51AF4F35.50503@rempel-privat.de>
	<51AF6F5D.5020400@rempel-privat.de>
Date: Thu, 6 Jun 2013 13:48:32 +0200
Message-ID: <CAGXE3d-kg7k=R81mKcqMfM9FFBDn0A9RNYmuTdQHXRUX37QhsA@mail.gmail.com> (sfid-20130606_134856_188078_8FC8DF7E)
Subject: Re: [PATCH] ath9k_htc: fix skb_under_panic error
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Marc Kleine-Budde <mkl@blackshift.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 5, 2013 at 7:03 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> I was running two stream netperf test for 2 hours without visible
> regressions.

With or without your pskb_expand_head patch applied?

Thanks,
Helmut
