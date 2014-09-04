Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47250 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaIDRPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 13:15:13 -0400
Date: Thu, 4 Sep 2014 13:12:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull request: iwlwifi 2014-09-01
Message-ID: <20140904171223.GD3467@tuxdriver.com> (sfid-20140904_191555_877425_65E2A91E)
References: <54041C13.7000905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54041C13.7000905@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 01, 2014 at 10:11:15AM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> I just came back from a long period of travels and I am really just starting to catch up.
> So this is the first pull request with various things that piled up, but I am really only
> in the middle of the patch list. I still wanted to send now these since they have been
> waiting for a while already.
> 
> I revert a patch that disabled CTS to self in dvm because users reported issues. The revert
> is CCed to stable since the offending patch was sent to stable too. I also bump the firmware
> API versions since a new firmware is coming up. On top of that, Marcel fixes a bug I introduced
> while fixing a bug in our Kconfig file.
> 
> Please pull and let me know if you have issues.
> Thanks!
> 
> 
> The following changes since commit 77b2f2865956b7573f9b040db7a9f808b434acd1:
> 
>   iwlwifi: mvm: disable scheduled scan to prevent firmware crash (2014-08-14 19:47:41 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to d88c8958dc13b4e4eb7fc57e3f06dc1c4abc7b1f:
> 
>   iwlwifi: bump firmware API version to 10 for 7000 and 8000 (2014-09-01 09:50:14 +0300)
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (2):
>       Revert "iwlwifi: dvm: don't enable CTS to self"
>       iwlwifi: bump firmware API version to 10 for 7000 and 8000
> 
> Marcel Holtmann (1):
>       iwlwifi: Remove module build requirement for Intel Wireless WiFi
> 
>  drivers/net/wireless/iwlwifi/Kconfig    |  2 --
>  drivers/net/wireless/iwlwifi/dvm/rxon.c | 12 ++++++++++++
>  drivers/net/wireless/iwlwifi/iwl-7000.c |  4 ++--
>  drivers/net/wireless/iwlwifi/iwl-8000.c |  2 +-
>  4 files changed, 15 insertions(+), 5 deletions(-)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
