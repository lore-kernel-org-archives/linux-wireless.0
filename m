Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35729 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934508AbZKYOPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 09:15:34 -0500
Date: Wed, 25 Nov 2009 09:06:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 1/5] libertas: rename mesh.c into persistcfg.c
Message-ID: <20091125140617.GD7800@tuxdriver.com>
References: <200911251308.55837.holgerschurig@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200911251308.55837.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 25, 2009 at 01:08:55PM +0100, Holger Schurig wrote:
> mesh.c will be the file where we concentrate all mesh-related
> code. This allows us to either add a KConfig entry for mesh and
> makes matters easier for the cfg80211 transition.
> 
> Signed-off-by: Holger Schurig <holgerschurig@gmail.com>
> ---
> 
> This is the equivalent of "git mv persistcfg.c mesh.c" and fixing up the Makefile
> 
>  drivers/net/wireless/libertas/Makefile     |    2 +-
>  drivers/net/wireless/libertas/mesh.c       |  453 ++++++++++++++++++++++++++++
>  drivers/net/wireless/libertas/persistcfg.c |  453 ----------------------------
>  3 files changed, 454 insertions(+), 454 deletions(-)
>  create mode 100644 drivers/net/wireless/libertas/mesh.c
>  delete mode 100644 drivers/net/wireless/libertas/persistcfg.c

Your subject is confusing, it seems backwards.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
