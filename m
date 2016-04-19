Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from che.mayfirst.org ([162.247.75.118]:48482 "EHLO che.mayfirst.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbcDSTcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 15:32:08 -0400
From: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, 821400@bugs.debian.org
Subject: brcmfmac_sdio should read its configs from efi vars, where applicable
Date: Tue, 19 Apr 2016 15:25:51 -0400
Message-ID: <87bn554czk.fsf@alice.fifthhorseman.net> (sfid-20160419_213212_676513_317C635E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Over in https://bugs.debian.org/821400, Ben Hutchings makes the
reasonable suggestion that where possible, when
brcm/brcmfmac43340-sdio.txt (or configuration file for other brcm
chipsets) is not available, brcmfmac_sdio should try looking for
configuration in the efi variables directly.

That would certainly make the common use case much simpler, which would
make the devices easier to use.

This is an attempt to report this suggestion upstream where it has a
chance of being implemented.  Feel free to redirect me if you think it
should be posted elsewhere.

Regards,

         --dkg
