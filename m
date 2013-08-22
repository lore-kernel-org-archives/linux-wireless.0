Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51267 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3HVSaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 14:30:12 -0400
Date: Thu, 22 Aug 2013 14:28:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2013-08-21
Message-ID: <20130822182827.GE1967@tuxdriver.com> (sfid-20130822_203036_076980_3F52C2FB)
References: <20130821161218.GH14645@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130821161218.GH14645@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 21, 2013 at 06:12:18PM +0200, Gustavo Padovan wrote:
> Hi John,
> 
> Patches to 3.12, here we have:
> 
> * implementation of a proper tty_port for RFCOMM devices, this fixes some
> issues people were seeing lately in the kernel.
> * Add voice_setting option for SCO, it is used for SCO Codec selection
> * bugfixes, small improvements and clean ups
> 
> Please pull, Thanks.
> 
> 	Gustavo
> 
> --
> The following changes since commit 72bb2f2678878dd4a758e628957f29ce28000d88:
> 
>   bgmac: make bgmac depend on bcm47xx (2013-07-24 11:05:19 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next master
> 
> for you to fetch changes up to 2dea632f9acad076370fe871d4ccc93868621403:
> 
>   Bluetooth: Add SCO connection fallback (2013-08-21 16:47:13 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
