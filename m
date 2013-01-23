Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:60620 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3AWVSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 16:18:51 -0500
Received: by mail-lb0-f170.google.com with SMTP id ge1so2897929lbb.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 13:18:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1357737477-39830-1-git-send-email-nbd@openwrt.org>
References: <1357737477-39830-1-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Wed, 23 Jan 2013 13:18:30 -0800
Message-ID: <CAB=NE6X=hapGB8t6O3+tV0kjiMGhn2bwXjDRc2Ju2De5PKNLyQ@mail.gmail.com> (sfid-20130123_221855_442825_6F588FE1)
Subject: Re: [PATCH] compat: fix compile errors when assembly is built into modules
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 9, 2013 at 5:17 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On powerpc, modules can be compiled and linked with an assembly file, adding
> missing symbols that the compiler references when using -Os.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

Thanks, I've applied this into my tree but I will send a respective
annotated patch with ckmake result to Hauke now that he's maintaining
compat / compat-drivers. I'll submit this patch and the backported
versions to Hauke / the list.

  Luis
