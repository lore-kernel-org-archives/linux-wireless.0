Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:36391 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700AbbICVvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 17:51:21 -0400
Received: by ykcf206 with SMTP id f206so3242139ykc.3
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2015 14:51:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAfyv36Xf4f33wZvKMeTomyr_T-LKKMYkpYQwWt6B83UthFr8Q@mail.gmail.com>
References: <CAAfyv36YLsEVarY6J8H-=Vcox=ktgeCUkqurHnAXzj_UFfthYw@mail.gmail.com>
	<26c3f35fd9e74b1d80e80077c19b6717@SC-EXCH04.marvell.com>
	<CAAfyv36Xf4f33wZvKMeTomyr_T-LKKMYkpYQwWt6B83UthFr8Q@mail.gmail.com>
Date: Thu, 3 Sep 2015 17:51:20 -0400
Message-ID: <CAOiWkA92XpC8jNq1SY_CDzNEbxNL=zrdAGMHQTs=CeLoYjSU4A@mail.gmail.com> (sfid-20150903_235125_442468_22B76F17)
Subject: Re: kernel log flooded with GET_CMD_NODE: cmd node not available
From: Marty Faltesek <mfaltesek@google.com>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2015 at 7:54 AM, Belisko Marek <marek.belisko@gmail.com> wrote:
> [  182.069146] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
> [  182.076350] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
> [  182.085102] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
> [  182.092297] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
> [  182.103276] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
> [  182.110478] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
> [  182.121156] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
> [  182.128360] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node
> [  182.134750] mwifiex_sdio mmc0:0001:1: GET_CMD_NODE: cmd node not available
> [  182.141927] mwifiex_sdio mmc0:0001:1: PREP_CMD: no free cmd node

We are also seeing these messages after recently switching to more
recent drivers.
