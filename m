Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40120 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbbCJRdE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 13:33:04 -0400
Message-ID: <1426008781.1926.7.camel@sipsolutions.net> (sfid-20150310_183308_539424_55BBDD28)
Subject: Re: [PATCH v2] mac80211: Get IV len from key conf and not cipher
 scheme
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Max Stepanov <Max.Stepanov@intel.com>
Date: Tue, 10 Mar 2015 18:33:01 +0100
In-Reply-To: <5842EA9CC042B141995329508713AD672105AA3E@ILMAIL1.corp.local>
References: <5842EA9CC042B141995329508713AD672105A9B0@ILMAIL1.corp.local>
	 <1426003477.1926.5.camel@sipsolutions.net>
	 <5842EA9CC042B141995329508713AD672105A9FB@ILMAIL1.corp.local>
	 <1426006121.1926.6.camel@sipsolutions.net>
	 <5842EA9CC042B141995329508713AD672105AA3E@ILMAIL1.corp.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-10 at 17:28 +0000, Cedric Izoard wrote:

> The other option I see, would be to add a pointer to the cipher scheme 
> in struct ieee80211_key. So that in TX cipher_scheme would be 
> test/accessed using key ptr. sta->cipher_scheme would still be used for RX.
> Do you consider this as a better option ?

A whole pointer seems a bit pointless, maybe a key flag would be better?

johannes

