Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55109 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbaFYTaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 15:30:09 -0400
Date: Wed, 25 Jun 2014 15:29:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com
Subject: Re: pull request: iwlwifi-next 2014-06-24
Message-ID: <20140625192934.GI3445@tuxdriver.com> (sfid-20140625_213018_253033_62A4558F)
References: <53A9D6CF.9040100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A9D6CF.9040100@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2014 at 10:51:43PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> This is a pull request for 3.17.
> 
> I have here a whole bunch of various things. Andy contributes better debug prints for dvm specific flows and a module parameter to completely disable power save for dvm. Andrei is sharing the premises of his work on CSA - more to come. Eran and Liad keep on working on the new devices. I have the regular amount of BT Coex stuff and I continue to work on the firmware error report system adding more debug capabilities. More to come on that subject too.
> 
> I merged iwlwifi-fixes in order to be able to apply patches that relied on patches there.
> 
> Let me know if you have problems - please pull.
> 
> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:
> 
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git master
> 
> for you to fetch changes up to c47af22ad630e03053f3eeefd19bd8274989ffbb:
> 
>   iwlwifi: mvm: handle device start failures during restart (2014-06-24 21:55:41 +0300)

Pulling now...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
