Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:60593 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3FKSv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:51:28 -0400
Received: from x61.home (mnch-5d872e8d.pool.mediaWays.net [93.135.46.141])
	by eazy.amigager.de (Postfix) with ESMTPA id 26332C8C0C9
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 20:51:26 +0200 (CEST)
Date: Tue, 11 Jun 2013 20:51:20 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Power saving features for iwl4965
Message-ID: <20130611185120.GA8751@x61.home> (sfid-20130611_205132_283036_2FD424D8)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com>
 <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130603141804.GA2146@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 03, 2013 at 16:18:05 +0200, Stanislaw Gruszka wrote:

> Could you try this experimental patch?

Hi,

on top of kernel 3.9.4 (with TuxOnIce patch), iwconfig wlan0 power on
now saves more than 1 W on my ThinkPad X61s with iwl4965. I can finally
switch to a recent kernel. Thanks a lot.

Regards,
Tino
