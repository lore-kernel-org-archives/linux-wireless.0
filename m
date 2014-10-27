Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46828 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaJ0SPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 14:15:14 -0400
Date: Mon, 27 Oct 2014 14:05:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
	Linux MIPS <linux-mips@linux-mips.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2 12/13] ath5k: update dependencies
Message-ID: <20141027180510.GF28300@tuxdriver.com> (sfid-20141027_191521_844829_87F258F1)
References: <1413932631-12866-1-git-send-email-ryazanov.s.a@gmail.com>
 <1413932631-12866-13-git-send-email-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1413932631-12866-13-git-send-email-ryazanov.s.a@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 22, 2014 at 03:03:50AM +0400, Sergey Ryazanov wrote:
> - Use config symbol defined in the driver instead of arch specific one for
>   conditional compilation.
> - Rename the ATHEROS_AR231X config symbol to ATH25.
> - Fix include (ar231x_platform.h -> ath25_platform.h).
> - Some of AR231x SoCs (e.g. AR2315) have PCI bus support, so remove !PCI
>   dependency, which block AHB support build.
> 
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> Cc: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: ath5k-devel@lists.ath5k.org

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
