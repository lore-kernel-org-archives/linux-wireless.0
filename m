Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58207 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab0GLRuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 13:50:11 -0400
Date: Mon, 12 Jul 2010 19:48:02 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	=?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch] prism54: call BUG_ON() earlier
Message-ID: <20100712174802.GE5658@bicker>
References: <20100710085338.GQ19184@bicker> <AANLkTikJ9Ae2HRIwdcc8oVgAc2zoVHUL7ZY9k2QO2QpS@mail.gmail.com> <20100712173714.GD5658@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100712173714.GD5658@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Of course the main reasons is that it silences a static checkers
warning.  :P

drivers/net/wireless/prism54/isl_ioctl.c +2073 send_simple_event(12)
	error: strcpy() 'str' too large for 'memptr' (257 vs 256)

regards,
dan carpenter
