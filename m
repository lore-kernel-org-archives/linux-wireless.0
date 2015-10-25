Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbbJYI0O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 04:26:14 -0400
Date: Sat, 24 Oct 2015 18:20:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org, Rachel Kim <rachel.kim@atmel.com>,
	devel@driverdev.osuosl.org, Chris Park <chris.park@atmel.com>,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>
Subject: Re: [PATCH 01/19] staging/wilc1000: remove unused functions
Message-ID: <20151025012040.GA7567@kroah.com> (sfid-20151025_092639_994120_99C022B8)
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
 <1445381258-1455986-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445381258-1455986-2-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2015 at 12:47:20AM +0200, Arnd Bergmann wrote:
> A number of symbols in the wilc1000 driver are completely unused
> and can be removed.
> This includes two variables that are only written but not read.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Due to other patches that were sent before yours for this driver, this
patch doesn't apply :(

Watch out, I'm getting about 50 patches a week for this driver, it's
under _heavy_ development, you will get merge issues...

Can you rebase the series on my staging-testing branch and resend?

thanks,

greg k-h
