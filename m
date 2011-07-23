Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55787 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1GWJnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 05:43:14 -0400
Received: by qwk3 with SMTP id 3so1462499qwk.19
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jul 2011 02:43:13 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110723072113.17363.59871.stgit@mj.roinet.com>
References: <20110723072113.17363.59871.stgit@mj.roinet.com>
Date: Sat, 23 Jul 2011 11:43:13 +0200
Message-ID: <CA+icZUWA1Qz3+NgFos+mb4ET_YYOnf089kozFUEExZ2UrY+qSw@mail.gmail.com> (sfid-20110723_114317_633751_E1FD94D3)
Subject: Re: [PATCH 1/3] ath5k: remove unused and write-only structures and fields
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 23, 2011 at 9:21 AM, Pavel Roskin <proski@gnu.org> wrote:
> struct ath5k_avg_val is unused.
>
> In struct ath5k_hw, lladdr, ah_radar and ah_mac_revision are write-only,
> rxbufsize is unused, ah_phy is write-only and referenced by unused
> macros.
>
> In struct ath5k_vif, lladdr is write-only.
>
> Remove AR5K_TUNE_RADAR_ALERT, which has no effect.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>
>

Tested on Atheros AR5212 chip against linux-next (next-20110722).

Feel free to add:

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

- Sedat -
