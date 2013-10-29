Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:57225 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3J2JfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 05:35:07 -0400
Received: by mail-ea0-f172.google.com with SMTP id r16so2787095ead.17
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 02:35:06 -0700 (PDT)
Message-ID: <526F8146.4080405@gmail.com> (sfid-20131029_103512_478234_79BABB1C)
Date: Tue, 29 Oct 2013 10:35:02 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: "Richard Wang rpw"@andrew.cmu.edu,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: Linksys AE3000 iw tool issues
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Wang wrote:

> succinctly. Based on other threads, it appeared as if there might be 
> support for rt2800usb for rt3573 chips in experimental versions 
> (http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2013-July/006283.html). 
> I tried to install the latest development version of backports hoping 
> that this patch would be part of it but it didn't seem to work. I'm 
> hoping to see if anyone happens to have a working patch for rt3573 chips.

Support for RT3573 was added recently, you should use wireless-next:
http://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git
or latest backports:
http://www.kernel.org/pub/linux/kernel/projects/backports/2013/10/25/backports-20131025.tar.bz2

