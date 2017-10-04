Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.linuxprofi.at ([93.83.54.199]:33204 "EHLO
        zimbra.linuxprofi.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750797AbdJDP5P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 11:57:15 -0400
From: =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph@boehmwalder.at>
To: johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        luciano.coelho@intel.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph@boehmwalder.at>
Subject: [PATCH 0/3] iwlwifi: cosmetic fixes
Date: Wed,  4 Oct 2017 17:56:57 +0200
Message-Id: <20171004155700.18048-1-christoph@boehmwalder.at> (sfid-20171004_180300_498224_C0DD16CA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix several code style issues, some of which were reported by checkpatch.pl.

The changes are:
* One instance of an `int` variable being used in a boolean context, chaned to
  use the more appropriate `bool` type.
* One very minor fix, removing a newline between a function definition and its
  associated `static` keyword
* One fix wrapping a macro in curly braces


Christoph Böhmwalder (3):
  wireless: iwlwifi: use bool instead of int
  wireless: iwlwifi: function definition cosmetic fix
  wireless: iwlwifi: wrap macro into braces

 drivers/net/wireless/intel/iwlwifi/iwl-io.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-phy-db.c | 16 +++++++---------
 2 files changed, 8 insertions(+), 10 deletions(-)

-- 
2.13.5
