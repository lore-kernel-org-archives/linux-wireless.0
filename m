Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768AbbBIItD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 03:49:03 -0500
Date: Mon, 9 Feb 2015 09:45:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sourav <sourav.chakraborty@netcommwireless.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: iw wlan0 set txpower ...does not work using rt2x00 drivers
Message-ID: <20150209084539.GB15797@redhat.com> (sfid-20150209_094910_384794_248E1BC2)
References: <54C18987.4080805@netcommwireless.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54C18987.4080805@netcommwireless.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2015 at 10:36:39AM +1100, Sourav wrote:
> Hi All,
> I am using rt2x00 drivers for RT3072 chipset.......for changing tx power, I
> am issuing "iw wlan0 set txpower fixed <value>".....The command succeeds(no
> error from command line).
> However the driver is not setting the value of the txpower....can you
> explain the logic of tx power setting by the driver and how to verify the
> change in txpower?

This is chanctx issue, tx power setting does not work at present for drivers
that do not use chanctx. I'm looking for proper fix for this problem ...

Stanislaw
