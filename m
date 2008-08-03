Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:23535 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbYHCASN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 20:18:13 -0400
Received: by an-out-0708.google.com with SMTP id d40so244808and.103
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 17:18:12 -0700 (PDT)
Message-ID: <43e72e890808021718j5012e602j6d3f570ad8fc4377@mail.gmail.com> (sfid-20080803_021817_401500_A13B67EB)
Date: Sat, 2 Aug 2008 17:18:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Subject: Re: [PATCH 00/12] ath9k: more cleanups for 2.6.27
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	jouni.malinen@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 2, 2008 at 4:48 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Here's another round of cleanups a few fixes for 2.6.27.

And here's the pull request if its easier:

The following changes since commit f870390ee6e15ce60ebfcef886b6b55e5f0157a7:
  Sujith Manoharan (1):
        Remove some unused macros

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/my-wireless-testing.git
ath9k-2008-08-02

Luis R. Rodriguez (3):
      ath9k: Port to new skb->cb mac80211 changes
      ath9k: Add initial link quality reporting
      ath9k: Use u8/u16/u32

Sujith Manoharan (9):
      ath9k: Fix whitespace damage
      ath9k: Update rate control after association
      ath9k: Channel cleanup
      ath9k: Fix channel registration
      ath9k: Consolidate channel list
      ath9k: Pass channel mode when setting a channel
      ath9k: Channel structure cleanup
      ath9k: We don't have a HAL anymore :)
      ath9k: Use standard error codes

 drivers/net/wireless/ath9k/ath9k.h    | 1087 +++++++++++------------
 drivers/net/wireless/ath9k/beacon.c   |  104 ++--
 drivers/net/wireless/ath9k/core.c     |  382 ++++----
 drivers/net/wireless/ath9k/core.h     |  311 +++----
 drivers/net/wireless/ath9k/hw.c       | 1633 ++++++++++++++++-----------------
 drivers/net/wireless/ath9k/hw.h       |  438 +++++-----
 drivers/net/wireless/ath9k/initvals.h |   82 +-
 drivers/net/wireless/ath9k/main.c     |  327 +++-----
 drivers/net/wireless/ath9k/phy.c      |   97 +--
 drivers/net/wireless/ath9k/phy.h      |   16 +-
 drivers/net/wireless/ath9k/rc.c       |  316 ++++----
 drivers/net/wireless/ath9k/rc.h       |   99 +-
 drivers/net/wireless/ath9k/recv.c     |   64 +-
 drivers/net/wireless/ath9k/regd.c     |  253 +++---
 drivers/net/wireless/ath9k/regd.h     |  132 ++--
 drivers/net/wireless/ath9k/xmit.c     |  221 +++---
 16 files changed, 2714 insertions(+), 2848 deletions(-)

  Luis
