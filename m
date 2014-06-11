Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:41483 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaFKTPU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 15:15:20 -0400
Received: by mail-qc0-f176.google.com with SMTP id r5so325440qcx.35
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 12:15:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140519185046.GH7650@tuxdriver.com>
References: <20140519185046.GH7650@tuxdriver.com>
Date: Wed, 11 Jun 2014 21:15:19 +0200
Message-ID: <CALhHN=pEo5H4AnWpOAhPs8LyK35wyhGJyvHTrh12nauQ-tOpDg@mail.gmail.com> (sfid-20140611_211524_453943_E572889A)
Subject: Re: [wireless-regdb] [ANN] wireless-regdb: master-2014-05-19
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 May 2014 20:50, John W. Linville <linville@tuxdriver.com> wrote:
> A new release of wireless-regdb (master-2014-05-19) is available at:
>
> http://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2014.05.19.tar.gz
>
> Here is the short log of the changes included since the 2013-11-27
> release:
>
> Bjørn Mork (1):
>       wireless-regdb: update NO's regulatory rules
>
> Janusz Dziedzic (3):
>       wireless-regdb: allow max bandwidth to be AUTO calculated
>       wireless-regdb: set AUTO bandwidth for world regulatory
This two above should not be merged. That was first version of auto
bandwidth calculation, we skip :)

>       wireless-regdb: add AUTO-BW rule flag
>
> Johannes Berg (1):
>       regdb: Republic of Korea: fix double rule
>
> John W. Linville (2):
>       wireless-regdb: correct some flag damage...
>       wireless-regdb: update regulatory.bin based on preceding changes.
>
> Luis R. Rodriguez (1):
>       wireless-regdb: embrace the Developer Certificate of Origin for contributions
>
> Ronald Wahl (1):
>       wireless-regdb: add channels 52..64 and 100..144 to world regdom
>
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
>
>
> _______________________________________________
> wireless-regdb mailing list
> wireless-regdb@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wireless-regdb
