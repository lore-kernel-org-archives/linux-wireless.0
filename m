Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60724 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbdJMJhm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 05:37:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: bcma: keep *config menu together
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <c4250321-0c2e-4f9c-7fea-aa1001d9c3a8@infradead.org>
References: <c4250321-0c2e-4f9c-7fea-aa1001d9c3a8@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-Id: <20171013093741.5629461256@smtp.codeaurora.org> (sfid-20171013_113756_517083_1C274727)
Date: Fri, 13 Oct 2017 09:37:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap <rdunlap@infradead.org> wrote:

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Use "if BCMA"/"endif" around all Kconfig symbols so that they are
> kept together in *config menus instead of showing up in unexpected
> places. Also remove "depends on BCMA" since this is handled by the
> "if BCMA" addition.
> 
> Tested with ARCH={x86_64,MIPS} using make {n,menu,g,x}config.
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Rafał Miłecki <zajec5@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

0f0a0af82626 bcma: keep *config menu together

-- 
https://patchwork.kernel.org/patch/9974679/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
