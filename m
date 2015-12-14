Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54911 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbbLNIsn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 03:48:43 -0500
Message-ID: <1450082912.3871.2.camel@sipsolutions.net> (sfid-20151214_094846_767669_53CDFE24)
Subject: Re: iwlwifi - L1 Enabled - LTR Enabled loop
From: Johannes Berg <johannes@sipsolutions.net>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linuxwifi <linuxwifi@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 14 Dec 2015 09:48:32 +0100
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E919DE2@hasmsx107.ger.corp.intel.com>
References: <CAB=NE6U5sh4cneaB5CGC7fSM_fKG_tBtmZ6sAo9Jswm1RBzd-g@mail.gmail.com>
	 <CAB=NE6VFo96M-ieCYPeDKncGJm+G1-_4gqKNDFen+K49-pLD4Q@mail.gmail.com>
	 <1449876779.2324.16.camel@sipsolutions.net> <566DF964.7050904@broadcom.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E919DE2@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-12-14 at 04:00 +0000, Grumbach, Emmanuel wrote:
> 
> This is really weird. I don't see how that could be firmware related.
> BTW, -10.ucode is fairly old :) we have -16.ucode out there.

I guess the question is how we get into this situation to start with?

About the only thing I can imagine is that we fail somehow during
initialization (without printing any other message) and higher layers
like wpa_supplicant/network-manager/... simply try to bring up the
device over and over again?

johannes
