Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54734 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab3BXJlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 04:41:20 -0500
Message-ID: <5129E036.9080209@hauke-m.de> (sfid-20130224_104123_508265_0360A9C4)
Date: Sun, 24 Feb 2013 10:41:10 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "W. Trevor King" <wking@tremily.us>
CC: arend@broadcom.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: [RFC 13/13] brcmsmac: activate AP support
References: <1361667972-22909-1-git-send-email-hauke@hauke-m.de> <1361667972-22909-14-git-send-email-hauke@hauke-m.de> <20130224023056.GH1361@odin.tremily.us>
In-Reply-To: <20130224023056.GH1361@odin.tremily.us>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/24/2013 03:30 AM, W. Trevor King wrote:
> On Sun, Feb 24, 2013 at 02:06:11AM +0100, Hauke Mehrtens wrote:
>> This activates the AP mode support. … /* Just STA for now */ -	if
>> (vif->type != NL80211_IFTYPE_STATION) { +	if (vif->type !=
>> NL80211_IFTYPE_STATION && +	    vif->type != NL80211_IFTYPE_AP)
>> {
> 
> The "Just STA" comment can probably go too ;).
Thanks I will change that, the message below also says sta only.

Hauke

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRKeA2AAoJEIZ0px9YPRMybA4P/ArfH7aBKoB1q+utXD44cFGB
SoAaDkYmhoyWE/M2ySQ+8IvSQiBXB1e1bs+6pHvf3FCPd2OM5JhOx4ok/Yu3TJWG
Q1SbhWGzFOKd0EqawvNZEAc2vwAsVqBC0+v9ktgLz6+H351Uv+nNEC223B8okHZr
XAgEhFg1ZFJzIkL/SkW9ZfCibdetU5ZBKpe2mw1Vd6jvOVluot6svsJ0m+b4boGK
a3w8CLTTL2N6DYaLahkZd4aNadCzKg6Wsd3gdLxFp3+nFDootgKMxZcHCPcZ+5LM
l+Z7daa2fl91qLv00DfXyeaBhcZyoYHy7P+kTGQf2N2uR1MkuNe7vmkpynQfcLIu
mgEBovx5193I82qN7+UNJnrXF5PQTcb3uktNYXiNXTzYHORp9NMlfH66b3VIX3p9
Ayn2Kxcm5vpao8p+OvAA0uFPE7UjVj3jO2SZ+Qcm3zEBC5/vQbW+XXpoadn5CnHs
uzHg2dAovV0hfUO8I6mtXUankshRMd23mhw8FJnwXmsw2CE82c/UKZqFJBe6cFju
C8KWY3G3GDTGHZ7n1o/4a43jzrnW+FBpMYYV7Deoz7CpqaquT9BELkbrjeYgrR+t
00It1ysQeNIG6tqZtlwhH4ZEjMrKKoOdn6xIwcdm7OSZCndveYFGJ6TkoklPyOro
2KdI/e13NF8y7XQ4PAGS
=oraK
-----END PGP SIGNATURE-----
