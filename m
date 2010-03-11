Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65378 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449Ab0CKSCV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 13:02:21 -0500
Received: by pvb32 with SMTP id 32so115460pvb.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 10:02:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e891003101544g46b1731fu9bb3dc1329b7d591@mail.gmail.com>
References: <19336.46643.733555.555640@gargle.gargle.HOWL>
	<20100310201609.GB3093@tuxdriver.com> <43e72e891003101544g46b1731fu9bb3dc1329b7d591@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Mar 2010 10:02:01 -0800
Message-ID: <43e72e891003111002l6076c21x6e8b4e291cfb44e8@mail.gmail.com>
Subject: Re: [PATCH 1/3] ath9k_htc: Add ath9k_htc driver
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sujith <Sujith.Manoharan@atheros.com>,
	linux-wireless@vger.kernel.org, Vasanth.Thiagarajan@atheros.com,
	Senthilkumar.Balasubramanian@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 10, 2010 at 3:44 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

> Hope that helps you assess whether or not this is 2.6.34 material.

John, sorry for this mess, this should be easier for you to decide. We
have decided to drop this series and we will resubmit an even more
cleaner patch series with better commit log entries *and* with Power
Save support and proper suspend/resume. I hope that in the next
iteration it will be clearer how this new driver patch for ath9k_htc
does not create an impact on the existing ath9k driver.

  Luis
