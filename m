Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36377 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbbEEWu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 18:50:26 -0400
Date: Tue, 5 May 2015 23:50:22 +0100
From: Okash Khawaja <okash.khawaja@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adm8211: fix the possible pci cache line sizes inside
 switch-case
Message-ID: <20150505225022.GA3877@bytefire-computer> (sfid-20150506_005047_358423_D7E138AC)
References: <20150505214851.GA3013@bytefire-computer>
 <1430863313.9365.49.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430863313.9365.49.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 05, 2015 at 03:01:53PM -0700, Joe Perches wrote:
> On Tue, 2015-05-05 at 22:48 +0100, Okash Khawaja wrote:
> > The PCI cache line size value, stored in cline variable, was being
> > compared against decimal values written as hex literals. This patch
> > changes those literals to correct hex values. 
> 
> This is fine.
> 
> The grammar might be better as something like:
> 
> The PCI cache line size value was being compared against
> decimal values prefixed with 0x.
> 
> Fix the literals to use the correct hex values. 
> 
> > Please note that this patch is on top of
> > another code cleanup patch '[PATCH] adm8211: fix checkpatch errors for
> > indentation and new line around switch-case'.
> 
> But this information doesn't belong here as
> it would also be in a git log when someone
> uses git am to apply it to a tree.
> 
> It'd be better to send a patch series using
> "git format-email --cover-letter -2 -o <dir>"
> and use git send-email for the series.
> 
> 
This is my first time going throug the process of submitting patches, something you may have already noticed. I have created and submitted patch series.Thanks

