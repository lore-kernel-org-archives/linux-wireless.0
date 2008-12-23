Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24641 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbYLWGIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 01:08:00 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 22:08:00 -0800
Date: Mon, 22 Dec 2008 22:07:53 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Xu, Martin" <martin.xu@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k:  whether "txpower off" is supported ?
Message-ID: <20081223060753.GS10807@tesla> (sfid-20081223_070808_118536_E332CA26)
References: <20081223050006.3710.98311.stgit@ct.roinet.com> <9F0C1DB20AFA954FA1DA05309350433D44333C66@pdsmsx503.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <9F0C1DB20AFA954FA1DA05309350433D44333C66@pdsmsx503.ccr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2008 at 09:25:20PM -0800, Xu, Martin wrote:
> Hi
> I found that iwconfig txpower off can not work on ath5k driver.
> Ath5k driver(drivers/net/wireless/ath5k/base.c: ath5k_config() ) does not implement the txpower features.
> Some one can confirm me whether txpower off feature has been implemented? If not, why? It is because of the HW limitation? Thanks!

If its not in yet its because no one yet has bothered with it.

> BTW:
> Where can I found the ath5k HW spec? Thanks!

Your source of documentation is the legacy-hal and Sam Leffler's HAL. Have you looked at those?

wget http://www.kernel.org/pub/linux/kernel/people/mcgrof/legacy-hal.tar.bz2
svn co http://svn.freebsd.org/base/projects/ath_hal

  Luis
