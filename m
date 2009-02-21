Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:63843 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043AbZBUAdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 19:33:23 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1443157wfa.4
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2009 16:33:22 -0800 (PST)
Subject: Re: [PATCH 0/6] b43: Use spatch to convert register accesses
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <200902201854.22114.mb@bu3sch.de>
References: <200902201854.22114.mb@bu3sch.de>
Content-Type: text/plain
Date: Fri, 20 Feb 2009 16:33:21 -0800
Message-Id: <1235176401.10163.4.camel@brick> (sfid-20090221_013327_202699_57532605)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-02-20 at 19:19 +0100, Michael Buesch wrote:
> Some time ago I rejected a bunch of patches that converted the
> PHY/radio register accesses to the new API. That was due to the patches
> being created manually. This introduces a huge potential to add new bugs.
> 
> However, this is an excellent task for coccinelle/spatch.
> So here's a series of patches, to convert the API usage, that were generated
> with spatch. This should keep the chances of breaking something as low as possible.
> 
> This reduces the .ko size by about 6 kiB.
> 
> The used semantic patches will be included in the patch headers.
> 
> John, please queue these patches for the next feature release.
> 

Shoot, I also redid the patches with spatch but never resubmitted.

Oh well.

Harvey


