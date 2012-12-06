Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:60743 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab2LFWkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 17:40:32 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so5772249lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Dec 2012 14:40:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
References: <1354817847-23440-1-git-send-email-juhosg@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 6 Dec 2012 14:40:11 -0800
Message-ID: <CAB=NE6V3t0XsKm=yxu1DzFf3uz5F1hh4fQJwMH404aMB=2j11A@mail.gmail.com> (sfid-20121206_234042_941541_B0D4FB1A)
Subject: Re: [PATCH v2 00/13] qca-swiss-army-knife: initvals fixes and improvements
To: Gabor Juhos <juhosg@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 6, 2012 at 10:17 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> This patch-set contain patches for the initvals tool.
> The first seven patches are fixing minor bugs, the next
> three imporves the code a bit and the last four patches
> are adding suport for AR9550.
>
> Changes since v1:
>   - rebase against the current version
>   - add four new patch to fix more issues
>
> Gabor Juhos (13):
>   qca-swiss-army-knife: refresh checksums.txt
>   qca-swiss-army-knife: fix ar9330_1p2_initvals.h
>   qca-swiss-army-knife: print AR9565 initvals
>   qca-swiss-army-knife: fix comment in ar9340_initvals.h
>   qca-swiss-army-knife: add missing families to verify_checksums.sh
>   qca-swiss-army-knife: fix string length for ar9340
>   qca-swiss-army-knife: add ar9462-2p0 to the usage text
>   qca-swiss-army-knife: reformat INI_PRINT_* macros
>   qca-swiss-army-knife: simplify initval family handling
>   qca-swiss-army-knife: allow to print initvals with more than 5 columns
>   qca-swiss-army-knife: add initval support for AR955X
>   qca-swiss-army-knife: add checksums for AR955X initvals
>   qca-swiss-army-knife: allow to verify AR955X initvals

Thanks, applied and pushed! I have a comment on a patch but that can
be reviewed and address if required through follow up patches if so
desired.

  Luis
