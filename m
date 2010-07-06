Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54673 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab0GFPzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 11:55:03 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTilfjBIbylUDKlTGiEC_U6pJnkC6HoENOzK2eFFq@mail.gmail.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	<1278376666-3509-5-git-send-email-ohad@wizery.com> <AANLkTilfjBIbylUDKlTGiEC_U6pJnkC6HoENOzK2eFFq@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 6 Jul 2010 18:54:41 +0300
Message-ID: <AANLkTinPL8tJTzb5fr2QNy8h1ANtTQZkrwQpUlx9B6Tr@mail.gmail.com>
Subject: Re: [PATCH 04/15] mmc: support embedded data field in mmc_host
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@arm.linux.org.uk,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	akpm@linux-foundation.org, San Mehat <san@google.com>,
	Ohad Ben-Cohen <ohadb@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 6, 2010 at 6:49 PM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> Hm, do we really need a Kconfig option just for a single pointer? It
> only saves sizeof(void *) bytes per host, but adds rather confusing
> config option for users and some ifdef complexity.

No strong feelings about it, I can remove that if preferred.

>
