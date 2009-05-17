Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62970 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbZEQPi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 11:38:58 -0400
MIME-Version: 1.0
In-Reply-To: <20090515144628.GE2773@tuxdriver.com>
References: <5a44caba0905150740n3bf90e05i17a74e82f35edcf4@mail.gmail.com>
	 <20090515144628.GE2773@tuxdriver.com>
Date: Sun, 17 May 2009 16:38:58 +0100
Message-ID: <5a44caba0905170838l2876df90q200f9a8b6411f7ce@mail.gmail.com>
Subject: Re: Regression: 2.6.30-rc5 and rt2x00 / rt2500pci
From: Ken Lewis <kennylewis@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org,
	linux-wireless@vger.kernel.org, davem@davemloft.net,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/5/15 John W. Linville <linville@tuxdriver.com>:
> On Fri, May 15, 2009 at 03:40:44PM +0100, Ken Lewis wrote:
>> I've been looking for a bug in Linux-Next that makes my rt2500pci
>> wireless card unusable. ...
>
> Please apply this patch:
>
>        http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/0002-mac80211-avoid-NULL-ptr-deref-when-finding-max_rate.patch
>
> A pull request was sent to Dave M. a couple of days ago.  I imagine
> that it will make its way to Linus shortly.

Thank you, John. The patch makes 2.6.30-rc5 work for me -- no more bug
dump and the wireless card works fine.

I'm about to try and see if it *also* makes rt2x00 work when applied
against the linux-next tree (and next-20090515 in particular).

Take care.
Ken.Lewis
