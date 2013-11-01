Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:49441 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KAN3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Nov 2013 09:29:04 -0400
Received: by mail-lb0-f172.google.com with SMTP id c11so3519343lbj.3
        for <linux-wireless@vger.kernel.org>; Fri, 01 Nov 2013 06:29:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383169509-22619-1-git-send-email-mcgrof@do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 1 Nov 2013 14:28:42 +0100
Message-ID: <CAB=NE6W+hf6_+d1Koz84GVcaFHK8xUperA9yht6WfyEw=Gs_pg@mail.gmail.com> (sfid-20131101_142908_774586_07E178A5)
Subject: Re: [PATCH 0/7] wireless-regdb: DFS regions and optimizations
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 30, 2013 at 10:45 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> This patch series associates a slew of countries
> to DFS regions and then provides updates to 4
> countries based on the new CRDA optimizer. The
> optimizations have no functional changes other
> than reducing the size of the regulatory domain
> data strucutre that would be used to send to
> the kernel.
>
> Luis R. Rodriguez (7):
>   wireless-regdb: add DFS FCC regions
>   wireless-regdb: add DFS ETSI regions

This patch was missing one country although the commit log mentioned it.

>   wireless-regdb: add DFS JP regions

This one as well.

>   wireless-regdb: optimize two of DE's rules
>   wireless-regdb: optimize two of ES's rules

This one conflicts with Xose's patch so I'll drop it.

>   wireless-regdb: optimize two of IL's rules
>   wireless-regdb: optimize two of NL's rules

I'll just respin.

  Luis
