Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:47920 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236AbZKDWzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 17:55:55 -0500
MIME-Version: 1.0
In-Reply-To: <14add3d10911041219j6ab25282re4f98d14029b1f68@mail.gmail.com>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	<14add3d10911041219j6ab25282re4f98d14029b1f68@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 5 Nov 2009 09:55:39 +1100
Message-ID: <646765f40911041455m7a6f55b8ka3ce95de7dd6ac6c@mail.gmail.com>
Subject: Re: [PATCH 00/41] rewritten rt2800 drivers
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bart,

FWIW, this all looks good to me, except for these comments:

1. When you introduce struct rt2800_ops, it may telegraph your
intentions more clearly if you introduce rt2800lib.h at the same time
- this also means that we don't have (if only for a single patch)
duplicate versions of this structure and it's associated code.

2. Patches #26-28 should arguably come before the conversions to use
the struct rt2800_ops methods.

3. I don't get the reasoning behind patch #37 (remove useless ifdefs
from rt2x00leds.h) but I'm going to assume that it's all right.

4. Patch #39 should arguably come earlier in the patch set as it's a
general cleanup.

Other than that, good work!

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
