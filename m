Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:42764 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaETH7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:59:50 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so81229lbi.9
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 00:59:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399624723-9167-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1399624723-9167-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 00:59:29 -0700
Message-ID: <CAB=NE6X76jCotGR+61wPxyu0treDTebXsxu-inU7xWJnMRLevA@mail.gmail.com> (sfid-20140520_095955_208452_1C8374D8)
Subject: Re: [PATCH] wireless-regdb: add AUTO-BW rule flag
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 9, 2014 at 1:38 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Sync with latest nl80211.h and add AUTO-BW flag.
> If this flag set, maximum available bandwidth should
> be calculated base on contiguous rules and wider channels
> will be allowed to cross multiple contiguous/overlapping
> frequency ranges.
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

Once John merges this I'll merge on CRDA, just as with the DFS CAC
patch, please do let me know if and when that happens.

  Luis
