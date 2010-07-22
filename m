Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44829 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0GVI4R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 04:56:17 -0400
Message-ID: <4C4807AD.5090302@gmail.com>
Date: Thu, 22 Jul 2010 10:56:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Bruno Randolf <br1@einfach.org>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] ath5k: snprintf() returns largish values
References: <20100722085202.GV17585@bicker>
In-Reply-To: <20100722085202.GV17585@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/22/2010 10:52 AM, Dan Carpenter wrote:
> snprintf() returns the number of characters that would have been written
> (not counting the NUL character).  So we can't use it as the limiter to 
> simple_read_from_buffer() without capping it first at sizeof(buf).

Doesn't scnprintf make more sense here?

thanks,
-- 
js
