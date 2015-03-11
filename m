Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48185 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbbCKQSD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2015 12:18:03 -0400
Message-ID: <1426090679.1904.5.camel@sipsolutions.net> (sfid-20150311_171807_797183_0EC665D4)
Subject: Re: [PATCH v3] mac80211:
 Get-IV-len-from-key-conf-and-not-cipher-scheme
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Stepanov, Max" <Max.Stepanov@intel.com>
Date: Wed, 11 Mar 2015 17:17:59 +0100
In-Reply-To: <5842EA9CC042B141995329508713AD672105ACA7@ILMAIL1.corp.local>
References: <5842EA9CC042B141995329508713AD672105ACA7@ILMAIL1.corp.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-11 at 15:06 +0000, Cedric Izoard wrote:
> When a key is installed using a cipher scheme, a new flag
> IEE80211_KEY_FLAG_CIPHER_SCHEME is set.
> This flag is used on TX path to test for "cipher scheme"
> key, instead of testing for sta->cipher_scheme as sta
> is NULL for bcast/mcast messages.
> For cipher scheme key, security header length is then
> read from key->conf.iv_len initialized with cs->hdr_len.

What happened to the subject? You also forgot to sign off this version.

johannes

