Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:44948 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130Ab1GQIQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 04:16:38 -0400
Received: by mail-ww0-f54.google.com with SMTP id 4so2271193wwf.23
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jul 2011 01:16:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <874o2nx16b.fsf@purkki.adurom.net>
References: <1310647673-10144-1-git-send-email-geryk@ti.com>
	<1310647673-10144-2-git-send-email-geryk@ti.com>
	<874o2nx16b.fsf@purkki.adurom.net>
Date: Sun, 17 Jul 2011 11:16:37 +0300
Message-ID: <CABB-i1foCSozXa1ZacqNPf_-vEUrw9uv+V6rraFhM-FoNoo3qg@mail.gmail.com> (sfid-20110717_101653_563427_B5ECCBEB)
Subject: Re: [PATCH 2/2] wl12xx Export chip id to sysfs
From: "Kahn, Gery" <geryk@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 15, 2011 at 13:56, Kalle Valo <kvalo@adurom.com> wrote:
> Gery Kahn <geryk@ti.com> writes:
>
>> Export the chip id to userspace. This helps to change application behavior
>> according to architecture of the wl12xx chip.
>
> We already support exporting this type of information through
> ethtool's ioctl interface using the wiphy.hw_version, which was
> specifially added for this purpose. That's much better than yet
> another sysfs file.
>
Right.
In PLT mode it didn't show any information, but
that might have been a mistake on our part.

I'll send another patch.

Gery
