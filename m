Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45613 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbbC3IkT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:40:19 -0400
Message-ID: <1427704814.26117.10.camel@sipsolutions.net> (sfid-20150330_104029_524948_3BEBBF43)
Subject: Re: [patch] mac80111: aes_ccm: cleanup
 ieee80211_aes_key_setup_encrypt()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 30 Mar 2015 10:40:14 +0200
In-Reply-To: <20150323140814.GA27609@mwanda>
References: <20150323140814.GA27609@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-23 at 17:08 +0300, Dan Carpenter wrote:
> This code is written using an anti-pattern called "success handling"
> which makes it hard to read, especially if you are used to normal kernel
> style.  It should instead be written as a list of directives in a row
> with branches for error handling.

Applied.

johannes

