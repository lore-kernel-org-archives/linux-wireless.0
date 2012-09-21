Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33954 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab2IUI1w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 04:27:52 -0400
Received: by wibhr14 with SMTP id hr14so1748707wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2012 01:27:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347483216-2309-1-git-send-email-zajec5@gmail.com>
References: <1347483216-2309-1-git-send-email-zajec5@gmail.com>
Date: Fri, 21 Sep 2012 10:27:51 +0200
Message-ID: <CACna6ryBiRQF5Xwjb0ysJ6YFnuSZSb5_st2A8eaL3BJ=b-exqA@mail.gmail.com> (sfid-20120921_102757_679846_494A1E71)
Subject: Re: [PATCH] bcma: export PLL reading function
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/9/12 Rafał Miłecki <zajec5@gmail.com>:
> This is required by NAND flash driver for initializing wait counters.

John: have you take a look at this patch? Can you take it or would you
prefer it to be submitted together with NAND driver (using different
than wireless tree)?

-- 
Rafał
