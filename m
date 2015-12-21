Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:7013 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbbLUHYI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 02:24:08 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: pull request: iwlwifi-2015-12-21
Date: Mon, 21 Dec 2015 07:24:03 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E9477A9@hasmsx107.ger.corp.intel.com> (sfid-20151221_082412_572643_C215F54C)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi guys,

We seem to have problem with iwlwifi-7265D-10.ucode which can be replaced by iwlwifi-7265-10.ucode without affecting anyone.
As a bonus, the size on disk is a bit reduced.

The following changes since commit bbe4917c054eb0a73e250c6363341e3bf6725839:

  WHENCE: use https://linuxtv.org for LinuxTV URLs (2015-12-07 02:17:20 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2015-12-21

for you to fetch changes up to bf8e868d1ea52c514eb450d89ff5457cd04ec27d:

  iwlwifi: replace 7265D-10.ucode by 7265-10.ucode (2015-12-21 09:09:18 +0200)

----------------------------------------------------------------
fix https://bugzilla.kernel.org/show_bug.cgi?id=109531
by replacing iwlwifi-7265D-10.ucode by
iwlwifi-7265-10.ucode

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: replace 7265D-10.ucode by 7265-10.ucode

 iwlwifi-7265D-10.ucode | Bin 740436 -> 21 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)  mode change 100644 => 120000 iwlwifi-7265D-10.ucode

