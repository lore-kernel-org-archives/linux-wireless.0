Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:55881 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645AbYE0K7A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2008 06:59:00 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K0wtL-00042U-1z
	for linux-wireless@vger.kernel.org; Tue, 27 May 2008 10:58:55 +0000
Received: from 62.28.35.120 ([62.28.35.120])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2008 10:58:55 +0000
Received: from tolas_feup by 62.28.35.120 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 27 May 2008 10:58:55 +0000
To: linux-wireless@vger.kernel.org
From: JMF <tolas_feup@hotmail.com>
Subject: Re: [PATCH] iwlwifi: fix oops on wep key insertion
Date: Tue, 27 May 2008 10:58:43 +0000 (UTC)
Message-ID: <loom.20080527T105701-941@post.gmane.org> (sfid-20080527_125910_149877_4E2EA0FD)
References: <1211865214-1640-1-git-send-email-joonwpark81@gmail.com> <1ba2fa240805262341s62f017e7ka7502cbe55c1d348@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@...> writes:

> WEP key is of fixed size 13 or  5 bytes, this setting should be
> refused somewhere in the mac wext handler.
> NACK.
> Tomas
 What about 256-bit WEP key (232-bit key I think), it won't be supported?


