Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:34085 "EHLO
	mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbcHDFzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 01:55:22 -0400
Received: by mail-yb0-f196.google.com with SMTP id x196so232688ybe.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2016 22:55:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1470257023-6747-1-git-send-email-dan.kephart@lairdtech.com>
References: <1470257023-6747-1-git-send-email-dan.kephart@lairdtech.com>
From: Steve deRosier <derosier@gmail.com>
Date: Wed, 3 Aug 2016 16:18:19 -0700
Message-ID: <CALupW3BOmVnx+9duo+to6Rev4OGnbH-Ofme5nb3cy1TEfxRSOw@mail.gmail.com> (sfid-20160804_075532_598120_91617E21)
Subject: Re: [PATCH] ath6kl: enable firmware crash dumps on the AR6004
To: engineering@keppy.com
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 3, 2016 at 1:43 PM,  <engineering@keppy.com> wrote:
> From: Dan Kephart <dan.kephart@lairdtech.com>
>
> The firmware crash dumps on the 6004 are the same as the 6003. Remove the
> statement guarding it from dumping on the 6004.  Renamed the
> REG_DUMP_COUNT_AR6003 to reflect support on both chips.
>
> Signed-off-by: Dan Kephart <dan.kephart@lairdtech.com>

Since ath6kl only supports the 6003 and 6004, this looks fine to me
and works OK on my platforms.

Reviewed-by: Steve deRosier <steve.derosier@lairdtech.com>
