Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35177 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540Ab0J1N55 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 09:57:57 -0400
Received: by qwf7 with SMTP id 7so1171618qwf.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 06:57:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101027142052.9607A9D401B@zog.reactivated.net>
References: <20101027142052.9607A9D401B@zog.reactivated.net>
From: Steve deRosier <steve@cozybit.com>
Date: Thu, 28 Oct 2010 06:57:31 -0700
Message-ID: <AANLkTi=c_B+MoZOTxJ+sW06EeBGS0U9oVq1yqdzCGZW1@mail.gmail.com>
Subject: Re: [PATCH v2] libertas: Fix sd8686 firmware reload
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	dcbw@redhat.com, libertas-dev@lists.infradead.org, pgf@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 27, 2010 at 7:20 AM, Daniel Drake <dsd@laptop.org> wrote:
> From: Paul Fox <pgf@laptop.org>
>
> For the SD8686, we cannot rely on the scratch register to read the firmware
> load status, because the same register is used for storing RX packet length.
> Broaden the check to account for this.
>
> The module can now be unloaded/reloaded successfully.
>
> Based on the implementation from libertas_tf.
>
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Signed-off-by: Steve deRosier <steve@cozybit.com>
