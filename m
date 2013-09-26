Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36994 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176Ab3IZTAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 15:00:17 -0400
Date: Thu, 26 Sep 2013 14:57:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	ath6kl-devel@qca.qualcomm.com
Subject: Re: Pull request: ath 20130930
Message-ID: <20130926185742.GC1931@tuxdriver.com> (sfid-20130926_210022_425107_81F77A92)
References: <87wqmyz5i9.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87wqmyz5i9.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 03, 2013 at 11:14:22AM +0300, Kalle Valo wrote:
> Hi John,
> 
> here are latest ath10k changes, I hope it's still time to get these to
> 3.12. The changelog for the pull request:
> 
> Bartosz dropped support for qca98xx hw1.0 hardware from ath10k, it's
> just too much to support it. Michal added support for the new firmware
> interface. Marek fixed WEP in AP and IBSS mode. Rest of the changes are
> minor fixes or cleanups.
> 
> The following changes since commit 9d0e2f0772d394060bf3b17cd1f3a35574365103:
> 
>   ath6kl: Fix invalid pointer access on fuzz testing with AP mode (2013-08-07 10:58:59 +0300)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to 763b8cd31493f452094fd0eaeedb8cad37c756a2:
> 
>   ath10k: add chip_id file to debugfs (2013-09-03 09:59:53 +0300)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
