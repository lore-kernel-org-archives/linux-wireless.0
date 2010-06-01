Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:17352 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab0FASMQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jun 2010 14:12:16 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1891984fga.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jun 2010 11:12:15 -0700 (PDT)
Subject: Re: IWL3945 problems in 2.6.35-rc1
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: sedat.dilek@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTinmjlukRABwWWVuO6VRHrULcqB7Zk_HQZSDicKr@mail.gmail.com>
References: <1275395142.14385.6.camel@maxim-laptop>
	 <1275404221.2839.2.camel@maxim-laptop>
	 <AANLkTinmjlukRABwWWVuO6VRHrULcqB7Zk_HQZSDicKr@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 21:12:09 +0300
Message-ID: <1275415929.3778.1.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-01 at 17:21 +0200, Sedat Dilek wrote: 
> Hi Maxim,
> 
> that's a known issue... and there were several mails to LKML and here
> on the ML (as I see you are very active on both lists :-)).
> Unfortunately, the patch in [1] didnt go into any (GIT) reposoitory. I know.
> 
> I am attaching the original patch and give it a meaningfull name, so
> people see it on patchwork.kernel.org (linux-wireless).

The patch appears the work, Thanks!

Now the only problem remains is that I can associate only when device is
in promisc mode.
I think it doesn't receive broadcast frames.

Best regards,
Maxim Levitsky


