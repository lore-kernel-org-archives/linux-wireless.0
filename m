Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:42015 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab3CSIiI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 04:38:08 -0400
Received: by mail-ob0-f171.google.com with SMTP id x4so172781obh.30
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 01:38:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363642245.26810.24.camel@shinybook.infradead.org>
References: <1362671247-10766-1-git-send-email-zajec5@gmail.com>
	<1363171283.32099.343.camel@i7.infradead.org>
	<CACna6ryEBFqg1ORRcbob+FWcFGiMt9fOfQAkAov9wmoR8M4Fxw@mail.gmail.com>
	<1363273116.4853.58.camel@i7.infradead.org>
	<CACna6ry4bxZROnoBpu7S39e+cDure79nmzhLY8228Zuxecdt3w@mail.gmail.com>
	<1363642245.26810.24.camel@shinybook.infradead.org>
Date: Tue, 19 Mar 2013 09:38:07 +0100
Message-ID: <CACna6ryWQotHJ+RTneJ_ESKppQ4Zv2XS=Xe1TrqwX8C94yTR9A@mail.gmail.com> (sfid-20130319_093813_600567_7DB5230E)
Subject: Re: [PATCH 00/13] b43: implement basic TX power mgmt
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/18 David Woodhouse <dwmw2@infradead.org>:
> On Sat, 2013-03-16 at 14:50 +0100, Rafał Miłecki wrote:
>> To verify my theory, could you try reverting
>> 4969b41798e512689bba57c8c44d873216eba814, AKA
>> b43: HT-PHY: enable basic TX power setup
>> ? Does reverting this patch brings you back ~4.1MiB/s?
>
> Fairly much, yes.

Thanks. I'll add workaround for your card, but it needs fixing reading
board info in ssb/bcma/b43.

-- 
Rafał
