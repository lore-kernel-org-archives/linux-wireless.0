Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaIZMZF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 08:25:05 -0400
Date: Fri, 26 Sep 2014 14:22:08 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: nick <yocto6@gmail.com>
Cc: IvDoorn@gmail.com, helmut.schaa@googlemail.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: FIXMEs in rt2800lib.c
Message-ID: <20140926122207.GA27809@redhat.com> (sfid-20140926_142543_274327_742E66E1)
References: <5424566B.6000206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5424566B.6000206@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2014 at 01:52:43PM -0400, nick wrote:
> I seem to be hitting to fix mes in the file I listed in the subject. Would someone tell me if it's Ok to remove
> the lines that over write certain registers.

No, as long you prove that they are not needed.

Stanislaw
