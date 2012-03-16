Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49518 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab2CPEC5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 00:02:57 -0400
Received: by bkcik5 with SMTP id ik5so2609019bkc.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 21:02:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120315110219.GA2335@redhat.com>
References: <CAG-2HqUqwHo_xgqC79riQF2DA4DPz1Qy5ZARQK8GT+tf_-UKRg@mail.gmail.com>
	<20120130184446.GB2493@tuxdriver.com>
	<CA++WF2PnEzS5CAfryaPrJSs3Xb3s0WK1zR7N5o8+ud2HiU5GCw@mail.gmail.com>
	<20120315110219.GA2335@redhat.com>
Date: Thu, 15 Mar 2012 21:02:56 -0700
Message-ID: <CA++WF2P8E=0Xym92MuU84RwaP5Y9uyCyqw5jefh25QDz-Cpzkw@mail.gmail.com> (sfid-20120316_050301_332237_2314CCD6)
Subject: Re: MAINTAINER NEEDED -- Re: status of ipw2x00
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Tom Gundersen <teg@jklm.no>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On 15 March 2012 04:02, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Are you plan to fix issues caused on current firmware loading changes on
> linux?

I was able to reproduce this issue; unfortunately, I don't have a
proper fix for it yet.

> We have a few bug reports about that:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=783708
> https://bugzilla.redhat.com/show_bug.cgi?id=802106

Thanks for the info, I will take a look.

Stanislav.
