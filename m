Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:48227 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380Ab3GVPsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 11:48:23 -0400
Received: by mail-ie0-f169.google.com with SMTP id at20so4764493iec.28
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jul 2013 08:48:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Date: Mon, 22 Jul 2013 17:48:22 +0200
Message-ID: <CAL1gcdMDqkM=qS63Sdh9Z3f08TtQLvSuJ8EpC_pJVzMjBnUXZQ@mail.gmail.com> (sfid-20130722_174837_945025_9BDCC01B)
Subject: Re: [PATCH v3 00/20] rt2x00: add experimental support for RT3593
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 8, 2013 at 4:08 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> This patch-set implements experiemental support for the
> RT3593 chipset. The patches are tested on the Linksys
> AE3000 USB device only, however other USB devices which
> are using the RT3573 chips might work as well.
>
> The patch-set depends on the following series:
> 'rt2x00: rt2800lib: add support for extended EEPROM of three-chain devices'
>
> Changes since v2:
>  - keep case values in aplhabetical order
>
> Changes since v1:
>  - add missing patch
>  - make Linksys AE3000 support optional
>

I finally found the time to look at this over the weekend. To me it
looks good enough for inclusion.

For the whole series:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

---
Gertjan
