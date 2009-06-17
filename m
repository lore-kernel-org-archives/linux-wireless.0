Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:55933 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756664AbZFQRg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 13:36:26 -0400
Date: Wed, 17 Jun 2009 20:36:25 +0300
From: Jouni Malinen <j@w1.fi>
To: Ramesh R <rramesh_1@yahoo.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Power save / 11v support feature
Message-ID: <20090617173625.GA25488@jm.kir.nu>
References: <933839.92475.qm@web54506.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <933839.92475.qm@web54506.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2009 at 09:09:21AM -0700, Ramesh R wrote:

> I am interested to work on the power save /  11v support. Is someone already working on this?

Well, I'm planning on implementing some of the 802.11v features once the
needed values for frame types etc. are allocated by ANA. As far as power
saving is concerned, I would be most likely to start with adding
WNM-Sleep Mode support in hostapd.

-- 
Jouni Malinen                                            PGP id EFC895FA
