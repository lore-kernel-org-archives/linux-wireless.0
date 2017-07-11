Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33250 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755444AbdGKHcC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Jul 2017 03:32:02 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: stas.yakovlev@gmail.com, kvalo@codeaurora.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH v2 00/10] Constify attribute_group structures
Date: Tue, 11 Jul 2017 13:01:29 +0530
Message-Id: <1499758291-24821-1-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170711_093309_048902_A51B3662)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

attribute_groups are not supposed to change at runtime. So mark the
non-const structs as const.

Arvind Yadav (10):
  [PATCH v2 01/10] net: cdc_ncm: constify attribute_group structures.
  [PATCH v2 02/10] net: can: at91_can: constify attribute_group structures.
  [PATCH v2 03/10] net: can: janz-ican3: constify attribute_group structures.
  [PATCH v2 04/10] wireless: ipw2200: constify attribute_group structures.
  [PATCH v2 05/10] wireless: ipw2100: constify attribute_group structures.
  [PATCH v2 06/10] wireless: iwlegacy: constify attribute_group structures.
  [PATCH v2 07/10] wireless: iwlegacy: Constify attribute_group structures.
  [PATCH v2 08/10] arcnet: com20020-pci: constify attribute_group structures.
  [PATCH v2 09/10] net: bonding: constify attribute_group structures.
  [PATCH v2 10/10] net: chelsio: cxgb3: constify attribute_group structures.

 drivers/net/arcnet/com20020-pci.c               | 2 +-
 drivers/net/bonding/bond_sysfs.c                | 2 +-
 drivers/net/can/at91_can.c                      | 2 +-
 drivers/net/can/janz-ican3.c                    | 2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 8 ++++++--
 drivers/net/usb/cdc_ncm.c                       | 2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c    | 2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2200.c    | 2 +-
 drivers/net/wireless/intel/iwlegacy/3945-mac.c  | 2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c  | 2 +-
 10 files changed, 15 insertions(+), 11 deletions(-)

-- 
1.9.1
