Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33928 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab0ERHsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 03:48:12 -0400
Received: by fxm10 with SMTP id 10so726666fxm.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 00:48:11 -0700 (PDT)
Date: Tue, 18 May 2010 09:47:45 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Jeff Hansen <x@jeffhansen.com>, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [patch -next 1/2 v2] ath9k/debug: improve the snprintf()
	handling
Message-ID: <20100518074601.GA25162@bicker>
References: <20100514132437.GG5695@bicker> <20100515133441.GB5381@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100515133441.GB5381@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 15, 2010 at 03:34:41PM +0200, Dan Carpenter wrote:
> The snprintf() function returns the number of bytes that *would* have
> been written (not counting the NULL terminator).  We want to pass NULL
> terminated strings to the user so we need to add one to the snprintf 
> return value.

Actually this is a filesystem so we don't want to pass null terminated
strings do we?  Probably the first version of this patch was the better
one.

(What I love about open source is the discussions.  But normally it's
not just one discussing and sending out patches to his ownself. :P).

regards,
dan carpenter
