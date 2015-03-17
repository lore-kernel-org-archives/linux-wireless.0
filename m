Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54531 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbbCQLep (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 07:34:45 -0400
Message-ID: <1426592082.1985.41.camel@sipsolutions.net> (sfid-20150317_123448_692912_EE1383DF)
Subject: Re: [PATCH v4] mac80211: Get IV len from key conf and not cipher
 scheme
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 17 Mar 2015 12:34:42 +0100
In-Reply-To: <5842EA9CC042B141995329508713AD672105BFDA@ILMAIL1.corp.local>
References: <5842EA9CC042B141995329508713AD672105BFDA@ILMAIL1.corp.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-17 at 10:47 +0000, Cedric Izoard wrote:
> When a key is installed using a cipher scheme, a new internal
> flag KEY_FLAG_CIPHER_SCHEME is set.
> This flag is used on TX path to test for "cipher scheme"
> key, instead of testing for sta->cipher_scheme as sta
> is NULL for bcast/mcast messages.
> For cipher scheme key, security header length is then
> read from key->conf.iv_len initialized with cs->hdr_len.

Applied.

johannes

