Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53393 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209AbaHNSaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 14:30:14 -0400
Date: Thu, 14 Aug 2014 14:21:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: pull request: iwlwifi-2014-08-14
Message-ID: <20140814182126.GE4953@tuxdriver.com> (sfid-20140814_203023_073549_C5E79BA8)
References: <CANUX_P0LJqMS40k=8jeie3q=nbXsA4qO39TL3G9gkp+cTshMCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P0LJqMS40k=8jeie3q=nbXsA4qO39TL3G9gkp+cTshMCw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 14, 2014 at 11:12:30AM -0700, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is a pull request with one patch that fixes an issue faced by Linus.
> 
> David Spinadel helped me debugging this and it appears that the
> firmware currently available doesn't support scheduled scan. So we
> disable that for now.
> 
> I am sorry - but I am travelling right now and my connection to the
> only computer that has my PGP signature is awfully slow...
> Please pull. I'll try to sign a reply to this message as soon as I can.
> 
> Thanks,
> 
> The following changes since commit 2da2c5854ed759a64f8a9231a7f544b472c3aa6d:
> 
>   net: wireless: ipw2x00: ipw2200.c: Cleaning up missing
> null-terminate after strncpy call (2014-08-11 14:43:51 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
> for-john
> 
> for you to fetch changes up to 77b2f2865956b7573f9b040db7a9f808b434acd1:
> 
>   iwlwifi: mvm: disable scheduled scan to prevent firmware crash
> (2014-08-14 19:47:41 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
