Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:65324 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab0AUSNF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 13:13:05 -0500
MIME-Version: 1.0
In-Reply-To: <4B5897C8.2080006@irobot.com>
References: <43e72e891001201213x6a2c203dl7121f2dde6d61fb9@mail.gmail.com>
	<4B5897C8.2080006@irobot.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 21 Jan 2010 10:12:45 -0800
Message-ID: <43e72e891001211012y4f4c8721t7eb9e0eea0221820@mail.gmail.com>
Subject: Re: FYI - new compat-wireless based on 2.6.33-rc4
To: Adam Wozniak <awozniak@irobot.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 21, 2010 at 10:07 AM, Adam Wozniak <awozniak@irobot.com> wrote:
> compat-wireless-2010-01-20.tar.bz2 does not compile cleanly on ARM
> architectures.
> Commenting out line 9 of compat-2.6.32.h (#include <asm/compat.h>) fixes the
> issue.
> There is no arch/arm/include/asm/compat.h
> I suspect there are several other architectures which have similar issues.
>

Thanks for the report, the asm/compat.h was needed as otherwise there
was a compile issue, not sure how to address this, hrm...

  Luis
