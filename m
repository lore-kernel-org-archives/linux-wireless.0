Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:63019 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab3DQMlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:41:14 -0400
Received: by mail-ie0-f179.google.com with SMTP id 16so1823201iea.10
        for <linux-wireless@vger.kernel.org>; Wed, 17 Apr 2013 05:41:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366200500-4661-8-git-send-email-stf_xl@wp.pl>
References: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
	<1366200500-4661-8-git-send-email-stf_xl@wp.pl>
Date: Wed, 17 Apr 2013 14:41:14 +0200
Message-ID: <CAL1gcdMcoam5m4aVpAkKBtOoLhXf2VVAjrL2FAxE9XAWx6YJpg@mail.gmail.com> (sfid-20130417_144119_223650_4D314A0D)
Subject: Re: [PATCH v2 07/11] rt2800: add rt2800_rx_filter_calibration procedure
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 17, 2013 at 2:08 PM,  <stf_xl@wp.pl> wrote:
> From: Stanislaw Gruszka <stf_xl@wp.pl>
>
> Add procedure for both bands filter calibration and use it on individual
> chipset init rfcsr subroutines.
>
> Remove "Set back to initial state" code for 3290 since vendor driver
> DPO_RT3290_LinuxSTA_V2600_20120508 does not include it.
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

---
Gertjan
