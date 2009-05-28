Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57255 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbZE1T27 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 15:28:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 May 2009 12:29:02 -0700
Date: Thu, 28 May 2009 12:29:07 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jal2@gmx.de" <jal2@gmx.de>,
	Peter Grabienski <Peter.Grabienski@Atheros.com>,
	Stephen Chen <Stephen.Chen@Atheros.com>,
	Michael Fortin <Michael.Fortin@Atheros.com>,
	Johnny Cheng <Johnny.Cheng@Atheros.com>,
	Yuan-Gu Wei <Yuan-Gu.Wei@Atheros.com>,
	"otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>
Subject: Re: [RFT 2/2] ar9170: add AVM FRITZ devices
Message-ID: <20090528192907.GE20870@tesla>
References: <1243475326-28867-1-git-send-email-lrodriguez@atheros.com> <1243475326-28867-3-git-send-email-lrodriguez@atheros.com> <1243495071.16631.4.camel@localhost.localdomain> <1243524158.19748.2.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1243524158.19748.2.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 28, 2009 at 08:22:38AM -0700, Pavel Roskin wrote:
> On Thu, 2009-05-28 at 09:17 +0200, Marcel Holtmann wrote:
> 
> > can't you make this part of use_device_id table? Syncing up with product
> > ids in two places is not a good idea.

I take it you mean usb_device_id, and sure driver_info.

> It would be even better to use an internal chip ID, an equivalent to the
> SREV register in ath5k and ath9k, if it exists in ar9170.

Not sure if such things exists.

  Luis
