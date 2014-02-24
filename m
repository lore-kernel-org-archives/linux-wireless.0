Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58003 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaBXTpQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 14:45:16 -0500
Date: Mon, 24 Feb 2014 14:42:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: pull request: iwlwifi 2014-02-23
Message-ID: <20140224194225.GC24810@tuxdriver.com> (sfid-20140224_204523_663683_1AC86328)
References: <530A49C8.8060502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530A49C8.8060502@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 23, 2014 at 09:19:36PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> One single patch for this pull request intended for 3.14.
> This should fix an issue raised in iwldvm when we have lots of association failures.
> There is a bugzilla for this bug - it hasn't been validated by the user, but I hope it will do the trick.
> 
> I hope I fixed my line wrapping issue this time. Let me know if you are still unhappy with the current format.
> 
> Thanks!
> The following changes since commit 205e2210daa975d92ace485a65a31ccc4077fe1a:
> 
>   iwlwifi: disable TX AMPDU by default for iwldvm (2014-02-13 15:24:35 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git master
> 
> for you to fetch changes up to ec6f678c74dbdb06a6a775bbb00f1d26c17c404b:
> 
>   iwlwifi: dvm: clear IWL_STA_UCODE_INPROGRESS when assoc fails (2014-02-20 19:16:27 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
