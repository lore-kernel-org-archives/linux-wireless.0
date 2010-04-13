Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33418 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0DMFf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 01:35:27 -0400
MIME-Version: 1.0
In-Reply-To: <m2s43e72e891004122151n2677a158o7f9aa8d054bf058e@mail.gmail.com>
References: <m2s43e72e891004122151n2677a158o7f9aa8d054bf058e@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 12 Apr 2010 22:35:06 -0700
Message-ID: <v2q43e72e891004122235p87e971c9o12986a064f7d2be1@mail.gmail.com>
Subject: Re: Compat-wireless for 2.6.34 - 802.11 and bluetooth backported
To: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 12, 2010 at 9:51 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> We're up to 2.6.34-rc4 upstream but we hadn't released a respective
> compat-wireless stable [1] tarball yet. I finally got some time so
> just posted one up [2], this gives us the 2.6.34-rc4 wireless
> subsystem, bluetooth subsystem and new wireless/bluetooth drivers
> compilable and installed on older kernels. Please report any issues
> ASAP. For details on changes you can refer to the
> ChangeLog-2.6.34-rc4-wireless [3].
>
> I only did a quick build test against 2.6.31 and it seems to compile
> fine :), more compile tests reports against older kernels and actual
> loading tests reports against different kernels are greatly
> appreciated.
>
>  Luis
>
> [1] http://wireless.kernel.org/en/users/Download/stable
> [2] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.34/compat-wireless-2.6.34-rc4.tar.bz2
> [3] http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.34/ChangeLog-2.6.34-rc4-wireless

Also just updated the tarballs for 2.6.32.11 and 2.6.33.2, and removed
the 2.6.30 and 2.6.31 tarballs since not even kernel.org supports
those anymore.

  Luis
