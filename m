Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52033 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaKQUaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 15:30:23 -0500
Date: Mon, 17 Nov 2014 15:29:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org,
	ath10k@lists.infradead.org
Subject: Re: Pull request: ath 20141117
Message-ID: <20141117202944.GE3511@tuxdriver.com> (sfid-20141117_213027_866760_98C66EBE)
References: <87r3x1oneo.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87r3x1oneo.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 17, 2014 at 05:30:07PM +0200, Kalle Valo wrote:
> Hi John,
> 
> new pull request again, here's the changelog:
> 
> ----------------------------------------------------------------------
> One ath6kl patch and rest for ath10k, but nothing really major which
> stands out. Most notable:
> 
> o fix resume (Bartosz)
> 
> o firmware restart is now faster and more reliable (Michal)
> 
> o it's now possible to test hardware restart functionality without
>   crashing the firmware using hw-restart parameter with
>   simulate_fw_crash debugfs file (Michal)
> 
> ----------------------------------------------------------------------
> 
> The following changes since commit 84cbf3a7592879810f80cece6c7f736f099ab163:
> 
>   ath10k: split ce pipe init/alloc further (2014-10-23 16:41:32 +0300)
> 
> are available in the git repository at:
> 
>   git://github.com/kvalo/ath.git for-linville
> 
> for you to fetch changes up to 9de8f26f0038133bdfb8cf847936645dab949d88:
> 
>   ath10k: fix mismatched wmi api call (2014-11-17 16:48:49 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
