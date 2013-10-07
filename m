Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab3JGI2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 04:28:22 -0400
Date: Mon, 7 Oct 2013 10:24:58 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ivdoorn@gmail.com, gwingerde@gmail.com, helmut.schaa@googlemail.com
Subject: Re: [regression] [bisected] rt2800pci doesn't work after
 9483f40d8d01918b399b4e24d0c1111db0afffeb
Message-ID: <20131007082457.GB2418@redhat.com> (sfid-20131007_102835_865448_27970C1B)
References: <39871380943748@web17j.yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <39871380943748@web17j.yandex.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 05, 2013 at 07:29:08AM +0400, Kirill Tkhai wrote:
> GIt bisect says the first bad commit is 9483f40d8d01918b399b4e24d0c1111db0afffeb:
> 
>         Author: Jakub Kicinski <kubakici@wp.pl>
>         Date:   Tue May 7 00:28:50 2013 +0200
> 
>             rt2x00pci: Use PCI MSIs whenever possible
> 
>             All PCIe devices must support MSIs, make use of them.

I posted revert of that patch some time ago, it's on the way
upstream/stable ...

Stanislaw
