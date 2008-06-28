Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42151 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752859AbYF1NRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 09:17:08 -0400
Date: Sat, 28 Jun 2008 10:17:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: drago01 <drago01@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] iwl3945: add support for RFKILL_STATE_HARD_BLOCKED
Message-ID: <20080628131701.GB871@khazad-dum.debian.net> (sfid-20080628_151712_281050_B117ACF7)
References: <f6ca9fed0806280115o409136a0x20b2109c25330b63@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0806280115o409136a0x20b2109c25330b63@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 28 Jun 2008, drago01 wrote:
> This patch fixes the rfkill states to set RFKILL_STATE_HARD_BLOCKED when the
> radio is disabled by a hardware killswitch.
> It does not allow setting the sw state while the device is blocked by
> a hardware rfkill switch.

See my comment on your other patch, the device should be able to
double-block.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
