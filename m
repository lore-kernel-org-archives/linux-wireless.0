Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaLXGIT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 01:08:19 -0500
Date: Tue, 23 Dec 2014 22:08:17 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aliaskei Tulia <alexey.tulia@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH v2] staging: rtl8723au: fix sparse warning
Message-ID: <20141224060817.GA14566@kroah.com> (sfid-20141224_070830_611943_AB90D029)
References: <20141224055521.GA16313@epbyminw1710.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141224055521.GA16313@epbyminw1710.minsk.epam.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 24, 2014 at 08:55:21AM +0300, Aliaskei Tulia wrote:
> drivers/staging/rtl8723au/core/rtw_xmit.c:2375 warning: symbol
> 'rtw_ack_tx_done23a' was not declared. Should it be static?
> 
> Function 'rtw_ack_tx_done23a' seems to be unused in current staging
> code.
> 
> Signed-off-by: Aliaskei Tulia <Aliaksei_Tulia@epam.com>

This email address doesn't match your From: line :(
