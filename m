Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48727 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab1FMRFz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 13:05:55 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTik=t+BC4uBzXac-Gn7RjhmrnbWX6g@mail.gmail.com>
References: <BANLkTik=t+BC4uBzXac-Gn7RjhmrnbWX6g@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 13 Jun 2011 10:05:34 -0700
Message-ID: <BANLkTiknNdznxtn11NG3Z4EEpuFc08Pzmg@mail.gmail.com> (sfid-20110613_190614_957206_E1B7AC6F)
Subject: Re: [ANN] acs: automatic channel selection utility for 802.11
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Bitterli <fbitterli@atheros.com>
Cc: linux-kernel@vger.kernel.org, hostap@lists.shmoo.com,
	Matt Smith <Matt.Smith@atheros.com>,
	Arun Venkataraman <arun.venkataraman@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 10, 2011 at 5:19 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:

>                    (busy time - tx time)
>    int_factor = ------------------------- *  3^(noise + min_noise)
>                   (active time - tx time)

Switching to a coefficient of 2 instead of 3 for the noise multiplier
to reflect the way power in "far-field" radiation decreases as the
square of distance from the antenna [1]. Thanks to Felix Bitterli for
the hint.

[1] http://en.wikipedia.org/wiki/Near_and_far_field

  Luis
