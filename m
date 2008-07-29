Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:40241 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbYG2LNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:13:46 -0400
Received: by ik-out-1112.google.com with SMTP id c28so4666561ika.5
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jul 2008 04:13:44 -0700 (PDT)
Subject: Re: question about open11s installation
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?Q?=EC=9E=84=EC=98=81=EB=B9=88?= <ybim@mmlab.snu.ac.kr>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1216984564.4758.2.camel@johannes.berg>
References: <da2e1ddd0807170905j5121737bia15429aee0f7ffd6@mail.gmail.com>
	 <1216313740.3422.44.camel@johannes.berg>
	 <da2e1ddd0807180151k707c77eeyf31b6ea2948c6ec3@mail.gmail.com>
	 <da2e1ddd0807242211n33473f06p74d6acdf75add678@mail.gmail.com>
	 (sfid-20080725_071110_391035_0D41264D)  <1216984564.4758.2.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 13:13:34 +0200
Message-Id: <1217330014.6379.5.camel@localhost> (sfid-20080729_131350_154692_A4F0A75B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-07-25 at 13:16 +0200, Johannes Berg wrote:
> > So there's some problem with mesh beaconing with b43 driver.

As it has been noted in a different thread, mesh beaconing in general
was broken by commit "revamp beacon configuration" (1d22d3f6e on
wireless testing). Reverting it will fix it by now and I will send a
patch against wireless-testing head fixing it as soon as possible.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


