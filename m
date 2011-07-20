Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53010 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632Ab1GTBjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 21:39:09 -0400
Received: by gxk21 with SMTP id 21so2046539gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 18:39:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110715002155.14332.3527.stgit@mj.roinet.com>
References: <20110715002155.14332.3527.stgit@mj.roinet.com>
Date: Wed, 20 Jul 2011 04:39:08 +0300
Message-ID: <CAFtRNNy3SvLXUJ8uaOibGfnynS7gwCOMW2x=cLhfPDf9aNw4vQ@mail.gmail.com> (sfid-20110720_033913_750358_FA5E8D68)
Subject: Re: [PATCH v2] ath5k: merge ath5k_hw and ath5k_softc
From: Nick Kossifidis <mickflemm@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/15 Pavel Roskin <proski@gnu.org>:
> Both ath5k_hw and ath5k_softc represent one instance of the hardware.
> This duplication is historical and is not needed anymore.
>
> Keep the name "ath5k_hw" for the merged structure and "ah" for the
> variable pointing to it.  "ath5k_hw" is shorter than "ath5k_softc", more
> descriptive and more widely used.
>
> Put the combined structure to ath5k.h where the old ath5k_softc used to
> be. Move some code from base.h to ath5k.h as needed.
>
> Remove memory allocation for struct ath5k_hw and the corresponding error
> handling.  Merge iobase and ah_iobase fields.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Thanks a lot Pavel ;-)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
