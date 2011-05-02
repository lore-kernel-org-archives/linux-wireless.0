Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm18.bullet.mail.bf1.yahoo.com ([98.139.212.177]:32062 "HELO
	nm18.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752233Ab1EBSBV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 14:01:21 -0400
Message-ID: <9223.32487.qm@web161608.mail.bf1.yahoo.com> (sfid-20110502_200124_096985_EEECB0C8)
Date: Mon, 2 May 2011 11:01:19 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Please fix compat-wireless for 2.6.34.9
To: linux-wireless@vger.kernel.org,
	Andreas Hartmann <andihartmann@01019freenet.de>
In-Reply-To: <4DBED54F.4020108@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



--- On Mon, 5/2/11, Andreas Hartmann <andihartmann@01019freenet.de> wrote:

> modprobe rt2800pci
> WARNING: Error inserting rfkill
> (/lib/modules/2.6.34.9-4-desktop/kernel/net/rfkill/rfkill.ko):
> Invalid
> module format
> WARNING: Error inserting cfg80211
> (/lib/modules/2.6.34.9-4-desktop/updates/net/wireless/cfg80211.ko):
> Invalid module format
> WARNING: Error inserting mac80211
> (/lib/modules/2.6.34.9-4-desktop/updates/net/mac80211/mac80211.ko):
> Invalid module format
> WARNING: Error inserting rt2x00lib
> (/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2x00lib.ko):
> Invalid module format
> WARNING: Error inserting rt2x00pci
> (/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2x00pci.ko):
> Invalid module format
> WARNING: Error inserting crc_ccitt
> (/lib/modules/2.6.34.9-4-desktop/kernel/lib/crc-ccitt.ko):
> Invalid
> module format
> WARNING: Error inserting rt2800lib
> (/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2800lib.ko):
> Invalid module format
> FATAL: Error inserting rt2800pci
> (/lib/modules/2.6.34.9-4-desktop/updates/drivers/net/wireless/rt2x00/rt2800pci.ko):

Hi,

Did you unload (all) the wireless modules before modprobe-ing rt2800pci?

Walter

