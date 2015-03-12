Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25399 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbbCLIIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 04:08:19 -0400
From: "Stepanov, Max" <Max.Stepanov@intel.com>
To: Cedric Izoard <Cedric.Izoard@ceva-dsp.com>
CC: johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v3] mac80211: Get IV len from key conf and not cipher
 scheme
Date: Thu, 12 Mar 2015 08:08:15 +0000
Message-ID: <3A934E7FDB083A4683727C7D377065954A237A1A@hasmsx109.ger.corp.intel.com> (sfid-20150312_090833_376533_39B30395)
References: <5842EA9CC042B141995329508713AD672105AD37@ILMAIL1.corp.local>
In-Reply-To: <5842EA9CC042B141995329508713AD672105AD37@ILMAIL1.corp.local>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-03-11 at 18:29+0000, Cedric Izoard wrote:
>When a key is installed using a cipher scheme, a new flag
>IEE80211_KEY_FLAG_CIPHER_SCHEME is set.
>This flag is used on TX path to test for "cipher scheme"
>key, instead of testing for sta->cipher_scheme as sta is NULL for bcast/mcast
>messages.
>For cipher scheme key, security header length is then read from key-
>>conf.iv_len initialized with cs->hdr_len.
>
>Signed-off-by: Cedric Izoard <cedric.izoard@ceva-dsp.com>

The patch looks fine to me.

Max
