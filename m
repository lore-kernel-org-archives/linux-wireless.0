Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f198.google.com ([209.85.216.198]:45913 "EHLO
	mail-px0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab0CMF4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Mar 2010 00:56:44 -0500
Received: by pxi36 with SMTP id 36so1075487pxi.21
        for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 21:56:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
References: <1268459216-22372-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 12 Mar 2010 21:56:24 -0800
Message-ID: <43e72e891003122156i53a1768do693d2cf17b038820@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] ath9k_hw: complete support for AR9271
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 12, 2010 at 9:46 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
>
> Sujith (12):
>  ath9k_hw: update initialization values for AR9271
>  ath9k_hw: add GPIO setup code for AR9271
>  ath9k_hw: skip chip tests for AR9271
>  ath9k_hw: fix RF analog setup for AR9271
>  ath9k_hw: fix TX descriptor setup for AR9271
>  ath9k_hw: Fix full sleep setup for AR9271
>  ath9k_hw: fix noisefloor history buffer usage on AR9271
>  ath9k_hw: restrict valid nf readings for AR9271 to -114
>  ath9k_hw: use the skip count for PA calibration on AR9271
>  ath9k_hw: always set the core clock for AR9271
>  ath9k_hw: add HTC init hardware call for special resets for AR9271
>  ath9k_hw: fix hardware deinit
>
>  drivers/net/wireless/ath/ath9k/calib.c    |   25 ++++--
>  drivers/net/wireless/ath/ath9k/hw.c       |  140 +++++++++++++++--------------
>  drivers/net/wireless/ath/ath9k/hw.h       |    8 ++
>  drivers/net/wireless/ath/ath9k/init.c     |    3 +
>  drivers/net/wireless/ath/ath9k/initvals.h |  141 +++++++++++++++++++++--------
>  drivers/net/wireless/ath/ath9k/mac.c      |    2 +-
>  drivers/net/wireless/ath/ath9k/phy.c      |    6 +-
>  drivers/net/wireless/ath/ath9k/reg.h      |    3 +
>  8 files changed, 209 insertions(+), 119 deletions(-)

You can find the trusty all-in-one git am'able file here, with the
older v2 ath9k_htc driver in case you want to help test or just yank
all these patches in one go:

http://bombadil.infradead.org/~mcgrof/tmp/ath9k-htc-v3.patch

sha1sum 5f7fc23d89e8e4b9b5df8f448f2c95425933b7cd

  Luis
