Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34102 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab0FBQxg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 12:53:36 -0400
Received: by fxm8 with SMTP id 8so2054284fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jun 2010 09:53:35 -0700 (PDT)
Subject: Re: IWL3945 problems in 2.6.35-rc1
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: sedat.dilek@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1275415929.3778.1.camel@maxim-laptop>
References: <1275395142.14385.6.camel@maxim-laptop>
	 <1275404221.2839.2.camel@maxim-laptop>
	 <AANLkTinmjlukRABwWWVuO6VRHrULcqB7Zk_HQZSDicKr@mail.gmail.com>
	 <1275415929.3778.1.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 19:53:30 +0300
Message-ID: <1275497610.32562.15.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-01 at 21:12 +0300, Maxim Levitsky wrote: 
> On Tue, 2010-06-01 at 17:21 +0200, Sedat Dilek wrote: 
> > Hi Maxim,
> > 
> > that's a known issue... and there were several mails to LKML and here
> > on the ML (as I see you are very active on both lists :-)).
> > Unfortunately, the patch in [1] didnt go into any (GIT) reposoitory. I know.
> > 
> > I am attaching the original patch and give it a meaningfull name, so
> > people see it on patchwork.kernel.org (linux-wireless).
> 
> The patch appears the work, Thanks!
And it still works.


> 
> Now the only problem remains is that I can associate only when device is
> in promisc mode.
> I think it doesn't receive broadcast frames.
Any update on this?
This is going to be real show stopper for normal users.
Its pretty much not possible to connect to open AP now unless promisc
mode is enabled. 


Best regards,
Maxim Levitsky
|


