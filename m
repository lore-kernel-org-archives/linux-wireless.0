Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25824 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755396Ab0ETWY2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 18:24:28 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 15:24:28 -0700
Date: Thu, 20 May 2010 15:24:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sam Ng <Sam.Ng@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Bruno Randolf <br1@einfach.org>,
	David Quan <David.Quan@Atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna
 configuration
Message-ID: <20100520222426.GH4566@tux>
References: <20100519012528.22206.77550.stgit@tt-desk>
 <201005201121.49846.br1@einfach.org>
 <AANLkTilG3c2UDEQa66PMvKysRVTt_dd-ZAS8FiDOe4Ob@mail.gmail.com>
 <201005201436.11667.br1@einfach.org>
 <AANLkTilk0CIkmmIsBzPwchd6EBIVavw9R1amiSgCZOrx@mail.gmail.com>
 <AANLkTinPVSkrawZ4OCjp6vb-f4bA7nSrmnXjRDi-Pvvm@mail.gmail.com>
 <BD672EAEE3AD2C47A7120B0973C3FB3A2DC1C779ED@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <BD672EAEE3AD2C47A7120B0973C3FB3A2DC1C779ED@SC1EXMB-MBCL.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just for clarification, these e-mails are on a public mailing list.

On Thu, May 20, 2010 at 03:14:01PM -0700, Sam Ng wrote:
> Just to be accurate, we do have pre-lln devices that support
> more than 1 antenna ie. slow/fast diversity

Right, this is the typical fixed anntena a, fixed anntena b, or
antenna diversity mode.

> and rangemax style 'beamforming'. However, all these devices
> have only 1 chain.

Thanks for the clarification Sam.

  Luis
