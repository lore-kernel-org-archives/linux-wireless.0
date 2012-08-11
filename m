Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52670 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab2HKAw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:52:56 -0400
Received: by obbuo13 with SMTP id uo13so3034943obb.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 17:52:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
References: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Aug 2012 17:52:35 -0700
Message-ID: <CAB=NE6UOms6_aSkFdwUtp28QBESnwH4bene3Mms-EkB41Ni0GQ@mail.gmail.com> (sfid-20120811_025259_188120_F368B893)
Subject: Re: [PATCH 0/4] compat: some fixes
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 10, 2012 at 5:30 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> With these patches and "compat: fixup error in no_printk definition" by
> Andy Gospodarek <andy@greyhouse.net> compat and compat-wireless are
> building for me on all supported kernel versions. There is also a patch
> for compat-wireless needed.
>
> Results of ckmake on compat and compat-wireless:
> Trying kernel 3.6.0-030600rc1-generic [OK]
> Trying kernel 3.5.0-030500-generic [OK]
> Trying kernel 3.4.7-030407-generic [OK]
> Trying kernel 3.3.8-030308-generic [OK]
> Trying kernel 3.2.26-030226-generic [OK]
> Trying kernel 3.1.10-030110-generic [OK]
> Trying kernel 3.0.39-030039-generic [OK]
> Trying kernel 2.6.39-02063904-generic [OK]
> Trying kernel 2.6.38-02063808-generic [OK]
> Trying kernel 2.6.37-02063706-generic [OK]
> Trying kernel 2.6.36-02063604-generic [OK]
> Trying kernel 2.6.35-02063513-generic [OK]
> Trying kernel 2.6.34-02063410-generic [OK]
> Trying kernel 2.6.33-02063307-generic [OK]
> Trying kernel 2.6.32-02063254-generic [OK]
> Trying kernel 2.6.31-02063113-generic [OK]
> Trying kernel 2.6.30-02063010-generic [OK]
> Trying kernel 2.6.29-02062906-generic [OK]
> Trying kernel 2.6.28-02062810-generic [OK]
> Trying kernel 2.6.27-02062731-generic [OK]
> Trying kernel 2.6.26-020626-generic [OK]
> Trying kernel 2.6.25-020625-generic [OK]
> Trying kernel 2.6.24-02062407-generic [OK]

Nice! Thanks so much for this, applied all compat and compat-drivers
patches and pushed (BTW we should start using compat-drivers for
subject soon).

  Luis
