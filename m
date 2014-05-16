Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55110 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626AbaEPSaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2014 14:30:11 -0400
Date: Fri, 16 May 2014 14:19:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull  request iwlwifi-next 2014-05-15
Message-ID: <20140516181907.GH3431@tuxdriver.com> (sfid-20140516_203018_154650_A82264F1)
References: <5374F373.6040902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 15, 2014 at 08:03:47PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is *not* the last pull request for 3.16 :)
> I have just enough content for a pull request and prefer to send it now, and have another (smaller) one later (not too late).
> Again, I had to merge iwlwifi-fixes.git to avoid a merge conflict.
> 
> Avri continues to work on the power code and Eran is improving the NVM handling as a preparations for new devices on which he works with Liad. Luca cleans up a bit the code while working on CSA. I have the regular BT Coex stuff and a small lockdep fix. Johannes has his regular amount of clean ups and improvements, the main one is the ability to leave 2 chains open to improve diversity and hence the throughput in high attenuation scenarios.
> 
> Please pull, thanks.
> 
> The following changes since commit 1c4abec0baf25ffb92a28cc99d4231feeaa4d3f3:
> 
>   iwlwifi: mvm: fix setting channel in monitor mode (2014-05-11 13:10:08 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git master
> 
> for you to fetch changes up to af7c603eb476216f1c27d82b802f0ce879c54ab3:
> 
>   iwlwifi: fix LED support Kconfig dependencies (2014-05-15 19:56:18 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
