Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34361 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab3JHS2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 14:28:09 -0400
Message-ID: <1381256865.13359.14.camel@jlt4.sipsolutions.net> (sfid-20131008_202814_304347_0F2381C7)
Subject: Re: [PATCH] mac80211: port CCMP to cryptoapi's CCM driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: David Laight <David.Laight@aculab.com>,
	"<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
	"<patches@linaro.org>" <patches@linaro.org>,
	"<linville@tuxdriver.com>" <linville@tuxdriver.com>
Date: Tue, 08 Oct 2013 20:27:45 +0200
In-Reply-To: <CAKv+Gu8D_7d=u1PGWuxoLEETHe8uJMby3K98uQWQn7tk=t_t_w@mail.gmail.com> (sfid-20131008_165219_112466_04B623B7)
References: <1381231915-24232-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1381233152.13359.10.camel@jlt4.sipsolutions.net>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B737B@saturn3.aculab.com>
	 <23D74823-0DE3-4A87-9E89-310F437A328D@linaro.org>
	 <1381239908.13359.12.camel@jlt4.sipsolutions.net>
	 <1381239951.13359.13.camel@jlt4.sipsolutions.net>
	 <CAKv+Gu8D_7d=u1PGWuxoLEETHe8uJMby3K98uQWQn7tk=t_t_w@mail.gmail.com>
	 (sfid-20131008_165219_112466_04B623B7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-10-08 at 16:52 +0200, Ard Biesheuvel wrote:

> However, personally I don't think this should be necessary and in fact
> my patch removes a stack allocation of u8[48] (from
> ieee80211_crypto_ccmp_decrypt() and from ccmp_encrypt_skb() in wpa.c)
> so it does even out a bit.

I tend to agree.

johannes

