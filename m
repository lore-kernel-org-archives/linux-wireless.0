Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48447 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaG2OaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 10:30:10 -0400
Date: Tue, 29 Jul 2014 10:21:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.17] NFC update
Message-ID: <20140729142117.GB13090@tuxdriver.com> (sfid-20140729_163015_154119_5FA60E24)
References: <20140723211107.GF455@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140723211107.GF455@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2014 at 11:11:07PM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> This is the NFC pull request for 3.17.
> This is a rather quiet one, we have:
> 
> - A new driver from ST Microelectronics for their NCI ST21NFCB,
>   including device tree  support.
> 
> - p2p support for the ST21NFCA driver
> 
> - A few fixes an enhancements for the NFC digital laye
> 
> Thanks in advance for pulling those in.
> 
> The following changes since commit 1d9e954e8b522ae37c7c0fdd791b5736321684a0:
> 
>   mwifiex: remove redundant timestamps in debug prints (2014-07-18 13:45:26 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.17-1
> 
> for you to fetch changes up to bf30a67c947ed57c1cf7c68a47dc24331458037e:
> 
>   NFC: digital: Add 'tg_listen_md' and 'tg_get_rf_tech' driver hooks (2014-07-23 01:17:31 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
