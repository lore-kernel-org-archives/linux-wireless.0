Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49249 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaGGTPM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 15:15:12 -0400
Date: Mon, 7 Jul 2014 15:00:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2014-07-05
Message-ID: <20140707190016.GC29650@tuxdriver.com> (sfid-20140707_211517_397917_61D20DFA)
References: <53B852D4.5060109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53B852D4.5060109@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 05, 2014 at 10:32:36PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> This pull request is intended for 3.a16.
> 
> I have here 2 patches that disable the usage of CTS to self. This keeps making trouble to the firmware and is not a really reliable protection anyway. We may re-enable it in the future, but in rarer cases. Along with this, I have a fix from Ilan that prevents a firmware assertion.
> 
> Please pull.
> 
> The following changes since commit a42c9fcc4a88cdd246fab3bcf06c4487afee3d88:
> 
>   Revert "iwlwifi: remove IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT flag" (2014-06-24 22:01:46 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to dc271ee0d04d12d6bfabacbec803289a7072fbd9:
> 
>   iwlwifi: mvm: disable CTS to Self (2014-07-03 20:55:18 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
