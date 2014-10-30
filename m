Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52735 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbaJ3TaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 15:30:14 -0400
Date: Thu, 30 Oct 2014 15:23:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi-next 2014-10-29
Message-ID: <20141030192308.GB3768@tuxdriver.com> (sfid-20141030_203037_301735_D33FF26D)
References: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P0TURG9GNMRUOTGFfh=qzSNKkDh9Gm7Asq5jXr=0gQgLg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2014 at 01:48:50PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> Here is a pull request for 3.19. More details below.
> 
> Thanks!
> 
> The following changes since commit 35a9ad8af0bb0fa3525e6d0d20e32551d226f38e:
> 
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
> (2014-10-08 21:40:54 -0400)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> tags/iwlwifi-next-for-john-2014-10-29
> 
> for you to fetch changes up to d9e4d61c5b900f6938b4aa49f25a0db37aeb23b6:
> 
>   iwlwifi: mvm: unref SCAN ref on scan completion (2014-10-29 13:14:41 +0200)
> 
> ----------------------------------------------------------------
> The big new thing here is netdetect which allows the
> firmware to wake up the platform when a specific network
> is detected. Along with that I have fixes for d3 operation.
> The usual amount of rate scaling stuff - we now support STBC.
> The other commit that stands out is Johannes's work on
> devcoredump. He basically starts to use the standard
> infrastructure he built.

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
