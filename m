Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46244 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab0IHXZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:25:54 -0400
Received: by pwi3 with SMTP id 3so276252pwi.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:25:54 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com
Subject: [PATCH 0/9] libertas_tf: Add libertas_tf_sdio to libertas_tf
Date: Wed,  8 Sep 2010 16:25:20 -0700
Message-Id: <1283988329-44549-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following series of patches adds an sdio driver to libertas_tf for the
support of the sd8686 thin firmware for OLPC.  This driver and firmware are
used by OLPC's XO-1.5 and some Gumstix platforms.

The firmware can be pulled from OLPC's site:
http://dev.laptop.org/pub/firmware/libertas/thinfirm/lbtf_sdio-9.0.7.p3.bin

Full project documentation is on OLPC's wiki:
http://wiki.laptop.org/go/Thinfirm_1.5

Further patches will follow this series with various fixes given to me by
the community, fixes to the libertas_tf_usb driver, and fixes for mesh.

These have been tested on OLPC's XO-1.5 with the thin firmware.

- Steve

[PATCH 1/9] libertas_tf: Add a sdio driver to libertas_tf
[PATCH 2/9] libertas_tf: deb_defs.h: Fix include guard
[PATCH 3/9] libertas_tf: Added fullmac mode support so firmware supports libertas driver
[PATCH 4/9] libertas_tf: Add firmware reset to sdio driver and attempt firmware reload
[PATCH 5/9] libertas_tf: Moved firmware loading to probe in order to fetch MAC address
[PATCH 6/9] libertas_tf: Fix to enable interrupts even when firmware has already started
[PATCH 7/9] libertas_tf: Add tx feedback to libertas_tf_sdio
[PATCH 8/9] libertas_tf: updated with beacon code
[PATCH 9/9] libertas_tf: Allow tx up to full chip buffers
