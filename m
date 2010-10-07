Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:44378 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754578Ab0JGBDi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 21:03:38 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0142713414
	for <linux-wireless@vger.kernel.org>; Thu,  7 Oct 2010 10:03:36 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH 4/5] nl80211/mac80211: Add channel utilization to survey
Date: Thu, 7 Oct 2010 10:03:37 +0900
Cc: linville@tuxdriver.com, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	adrian@freebsd.org, vasanth@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <20101005095510.3083.46174.stgit@tt-desk> <20101005095526.3083.82322.stgit@tt-desk> <AANLkTimpPuwDFUidUprBkLoJrpr=5tnwCcNcnHmfT_Z7@mail.gmail.com>
In-Reply-To: <AANLkTimpPuwDFUidUprBkLoJrpr=5tnwCcNcnHmfT_Z7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010071003.37599.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed October 6 2010 18:54:37 Helmut Schaa wrote:
> On Tue, Oct 5, 2010 at 11:55 AM, Bruno Randolf <br1@einfach.org> wrote:
> > This adds three new values to the survey results:
> > 
> >  * BUSY - percentage of time the channel was busy
> >  * BUSY_TX - percentage of time spent transmitting frames
> >  * BUSY_RX - percentage of time spent receiving frames
> 
> Does BUSY include BUSY_RX and BUSY_TX already? At least on
> rt2800 devices we only have access to BUSY which already includes
> BUSY_RX and TX.

yes, BUSY includes TX and RX.
 
> And what about BUSY on the secondary channel in case of 40Mhz?

i have no information about that. luis?

bruno
