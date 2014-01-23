Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35501 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbaAWTPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 14:15:16 -0500
Date: Thu, 23 Jan 2014 14:01:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: pull request: iwlwifi-next 2014-1-20
Message-ID: <20140123190123.GD4309@tuxdriver.com> (sfid-20140123_201531_920027_11CCDE69)
References: <52DCFE87.9080103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52DCFE87.9080103@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 20, 2014 at 12:46:31PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> Well... I know... Not something to be proud of...
> 
> A critical bug has been reported on all NICs supported by iwldvm.
> iwlwifi would simply panic upon interface up This patch fixes this. The
> offending code is by me and is present in wireless-next.git and hence in
> net-next.git.
> I hope that this pull reuqest can reach 3.14-rc1 otherwise, all the
> system with NICs supported by iwldvm will simply lock up.
> 
> Thanks!
> 
> 
> The following changes since commit cf38e4f756d6396657c76f72ef42b6f47c523f97:
> 
>   iwlwifi: mvm: don't use highest rate in VHT MCS Set (2014-01-13
> 22:17:22 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
> for-john
> 
> for you to fetch changes up to 23e76d1a516eef416fb5c038791e943fc0916b67:
> 
>   iwlwifi: pcie: don't panic on host commands in iwldvm (2014-01-20
> 12:32:06 +0200)
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: pcie: don't panic on host commands in iwldvm
> 
>  drivers/net/wireless/iwlwifi/pcie/tx.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
