Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58794 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbaBXUPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 15:15:31 -0500
Date: Mon, 24 Feb 2014 15:03:06 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl-devel@qca.qualcomm.com,
	ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20140217
Message-ID: <20140224200305.GF24810@tuxdriver.com> (sfid-20140224_211539_152386_81DE66D1)
References: <87txbx3etu.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87txbx3etu.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 17, 2014 at 06:05:01PM +0200, Kalle Valo wrote:
> Hi John,
> 
> here's a new pull request for ath6kl and ath10k. 
> 
> For ath10k Alexander did some cleanup to PCI error cases and switched
> ath10k to use pci_enable_msi_range(). Michal implemented AP CSA support
> and sta_rc_update() operation. I enabled firmware "STA quick kickout"
> functionality for faster detection of disappeared clients.
> 
> Also there are lots of small fixes to everywhere from various people.
> 
> For ath6kl Julien did two small USB related fixes.
> 
> Please let me know if there are any problmes
> 
> The following changes since commit 38dbfb59d1175ef458d006556061adeaa8751b72:
> 
>   Linus 3.14-rc1 (2014-02-02 16:42:13 -0800)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to 9797febc4cc112869b19a110f70e0dedb1bb63d6:
> 
>   ath10k: implement sta_rc_update() (2014-02-15 08:49:02 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
