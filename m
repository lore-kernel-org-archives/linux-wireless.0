Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44848 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaCNSpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 14:45:09 -0400
Date: Fri, 14 Mar 2014 14:33:40 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2014-03-11
Message-ID: <20140314183339.GC20339@tuxdriver.com> (sfid-20140314_194513_996439_871352A3)
References: <531EF845.2050609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <531EF845.2050609@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 11, 2014 at 01:49:25PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> One more bugfix - this bug has been there forever, so it might not be all that much important. Your call.
> 
> We were sending a host command while the mutex wasn't held. This led to hard-to-catch races.
> 
> Please pull - thanks.
> 
> 
> The following changes since commit acfcd9ed588465e48efe5ceb67177096d51c95a9:
> 
>   iwlwifi: fix and add 7265 series HW IDs (2014-03-04 19:30:06 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to 82e5a649453a3cf23516277abb84273768a1592b:
> 
>   iwlwifi: dvm: take mutex when sending SYNC BT config command (2014-03-11 13:15:16 +0200)

Pulling now (for -next)...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
