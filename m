Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42969 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZAXGEn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 01:04:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [PATCH] wireless-regdb: adds a manpage for regulatory.bin, updates Makefile
Date: Sat, 24 Jan 2009 07:04:24 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <1232751387-22651-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1232751387-22651-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901240704.24281.mb@bu3sch.de> (sfid-20090124_070447_843149_C5788986)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 23:56:27 Luis R. Rodriguez wrote:
> This adds a man page for the regulatory.bin file and updates
> the Makefile to make it the install target flexible for distributions.
> As part of the install you also now get the the man page.
> 
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  Makefile         |   19 +++++++++++++++----
>  regulatory.bin.5 |   37 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+), 4 deletions(-)
>  create mode 100644 regulatory.bin.5
> 
> diff --git a/Makefile b/Makefile
> index 07c3030..0171196 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -2,12 +2,16 @@
>  PREFIX = /usr
>  CDRA_PATH = $(PREFIX)/lib/crda
>  
> +SBINDIR ?= /sbin/
> +MANDIR ?= $(PREFIX)/share/man/

Why do you define SBINDIR? It doesn't seem to be used.

-- 
Greetings, Michael.
