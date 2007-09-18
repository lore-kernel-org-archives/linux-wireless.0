Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42126 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754616AbXIRK1P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 06:27:15 -0400
Date: Tue, 18 Sep 2007 11:34:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"Jeff Garzik" <jeff@garzik.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
Message-ID: <20070918113401.6a8a737f@the-village.bc.nu>
In-Reply-To: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 17 Sep 2007 16:22:07 -0400
"Luis R. Rodriguez" <mcgrof@gmail.com> wrote:

> This patch updates the pci_iomap() kernel-doc to make it clarify the
> case when read*()/write*() can be called over ioread*/iowrite*(). When
> driver writers read this documenation sometimes it is assumed you just
> *need* to use ioread*()/iorwrite*(). We have an exception so lets just
> clarify this is not true for the exception.
> 
>  lib/iomap.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>

Reviewed-by: Alan Cox <alan@redhat.com>

Although I would say s/recommended/required/

Alan
