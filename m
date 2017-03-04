Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35226 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751577AbdCDP5t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Mar 2017 10:57:49 -0500
From: Arushi Singhal <arushisinghal19971997@gmail.com>
To: w.d.hubbs@gmail.com
Cc: chris@the-brannons.com, outreachy-kernel@googlegroups.com,
        kirk@reisers.ca, samuel.thibault@ens-lyon.org,
        gregkh@linuxfoundation.org, speakup@linux-speakup.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        linux-wireless@vger.kernel.org,
        Arushi Singhal <arushisinghal19971997@gmail.com>
Subject: [PATCH 0/6] multiple checkpatch issues
Date: Sat,  4 Mar 2017 21:27:34 +0530
Message-Id: <20170304155740.26105-1-arushisinghal19971997@gmail.com> (sfid-20170304_165816_431221_3EFCE407)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improve readability by fixing multiple checkpatch.pl
issues. 

Arushi Singhal (6):
  staging: speakup: fixes braces {} should be used on all arms of this statement
  staging: speakup: Avoid multiple assignments on same line
  staging: speakup: identation should use tabs
  staging: wilc1000: Alignment should match open parenthesis
  staging: wilc1000: function prototype argument should have identifier name
  staging: wilc1000: Logical continuations should be on the previous line

 drivers/staging/speakup/main.c                    |  6 +++--
 drivers/staging/speakup/speakup_decext.c          |  6 ++---
 drivers/staging/speakup/speakup_decpc.c           | 10 ++++----
 drivers/staging/speakup/speakup_dectlk.c          |  6 ++---
 drivers/staging/speakup/varhandlers.c             | 12 ++++++----
 drivers/staging/wilc1000/host_interface.c         |  2 +-
 drivers/staging/wilc1000/wilc_spi.c               |  6 ++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 28 +++++++++++------------
 drivers/staging/wilc1000/wilc_wlan.c              | 10 ++++----
 drivers/staging/wilc1000/wilc_wlan.h              |  6 ++---
 10 files changed, 48 insertions(+), 44 deletions(-)

-- 
2.11.0
