Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48556 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933375AbcCJH3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 02:29:22 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi -21.ucode firmware
Date: Thu, 10 Mar 2016 07:29:15 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32EA66A24@hasmsx107.ger.corp.intel.com> (sfid-20160310_082927_889473_A6D4DCDA)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kyle,

This is a pull request to include our latest available firmware into
mainline linux-firmware.git.

It includes -21.ucode for various devices including devices for which
this is the first supported firmware (3168 and 8265).
This firmware is supported starting kernel 4.6.

Please pull!

Thank you.

The following changes since commit 8d1fd61a3723ab8cb6b7bfeb8be38e16282cc1ed:

nvidia: Add GM20B signed firmware (2016-02-23 18:48:41 +0900)

are available in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git
tags/iwlwifi-fw-2016-03-09

for you to fetch changes up to a2c354e64cec4b1146054c7e5b7df4329af752a7:

iwlwifi: add new -21.ucode for 7265D, 8260, 3168 and 8265 devices
(2016-03-09 22:41:59 +0200)

----------------------------------------------------------------
This includes -21.ucode for the following devices:
* 7265D
* 3165
* 8260
* 3168 (new device)
* 8265 (new device)

----------------------------------------------------------------
Emmanuel Grumbach (1):
iwlwifi: add new -21.ucode for 7265D, 8260, 3168 and 8265 devices

iwlwifi-3168-21.ucode | Bin 0 -> 1384856 bytes
iwlwifi-7265D-21.ucode | Bin 0 -> 1385368 bytes
iwlwifi-8000C-21.ucode | Bin 0 -> 2394060 bytes
iwlwifi-8265-21.ucode | Bin 0 -> 2389968 bytes
4 files changed, 0 insertions(+), 0 deletions(-)
create mode 100644 iwlwifi-3168-21.ucode
create mode 100644 iwlwifi-7265D-21.ucode
create mode 100644 iwlwifi-8000C-21.ucode
create mode 100644 iwlwifi-8265-21.ucode
