Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751238AbdIPC70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 22:59:26 -0400
Date: Fri, 15 Sep 2017 21:59:23 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwifi@intel.com, linux-wireless@vger.kernel.org,
        Srinath Mannam <srinath.mannam@broadcom.com>,
        Jens Axboe <axboe@kernel.dk>, Luca Coelho <luca@coelho.fi>,
        Johannes Berg <johannes@sipsolutions.net>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [GIT PULL] PCI fixes for v4.14
Message-ID: <20170916025923.GA16731@bhelgaas-glaptop.roam.corp.google.com> (sfid-20170916_045945_844198_EC906481)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCI fix:

  - revert an attempt to fix a race while enabling upstream bridges because
    it broke iwlwifi firmware loading


The following changes since commit 711aab1dbb324d321e3d84368a435a78908c7bce:

  vfs: constify path argument to kernel_read_file_from_path (2017-09-14 20:18:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v4.14-fixes-1

for you to fetch changes up to 0f50a49e3008597abed0fff052d487f77db89093:

  Revert "PCI: Avoid race while enabling upstream bridges" (2017-09-15 01:33:51 -0500)

----------------------------------------------------------------
pci-v4.14-fixes-1

----------------------------------------------------------------
Bjorn Helgaas (1):
      Revert "PCI: Avoid race while enabling upstream bridges"

 drivers/pci/pci.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)
