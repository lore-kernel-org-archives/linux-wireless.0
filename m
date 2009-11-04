Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:60306 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbZKDT4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 14:56:48 -0500
MIME-Version: 1.0
In-Reply-To: <20091104173500.28463.89800.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
	 <20091104173500.28463.89800.sendpatchset@localhost.localdomain>
Date: Wed, 4 Nov 2009 20:56:47 +0100
Message-ID: <14add3d10911041156n7c9fd3a3s8437e2c7f6291830@mail.gmail.com>
Subject: Re: [PATCH 25/41] rt2800pci: convert to use struct rt2800_ops methods
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 6:35 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2800pci: convert to use struct rt2800_ops methods
>
> Add chipset registers access abstraction layer and prepare for later
> code unification.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
