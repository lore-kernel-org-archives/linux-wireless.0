Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gerolde.archlinux.org ([66.211.214.132]:36170 "EHLO
	archlinux.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753800Ab0KXRFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 12:05:46 -0500
Message-ID: <4CED4464.2000106@archlinux.org>
Date: Wed, 24 Nov 2010 17:59:16 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ANN] wireless-regdb: master-2010-11-22
References: <E1PKkCh-0005Ay-R2@sipsolutions.net>
In-Reply-To: <E1PKkCh-0005Ay-R2@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 23.11.2010 05:10, schrieb
wireless-cdvu00un1VgdHxzADdlk8Q@public.gmane.org:
> A new release of wireless-regdb (master-2010-11-22) is available at:
> 
> http://wireless.kernel.org/download/wireless-regdb/wireless-regdb-2010.11.22.tar.bz2
> 
> SHA1 sum: d0b008b4d32105cf6a87860b5a69e8066b03baaa
> 
> 
> For your convenience the individual regulatory.bin file can be downloaded from:
> 
> http://wireless.kernel.org/download/wireless-regdb/regulatory.bins/2010.11.22-regulatory.bin
> 
> SHA1 sum d7e558216ebe4d5ad01ccb0029c64456f740b9fd

Hello,

the binary does not work for me:

$ sha1sum 2010.11.22-regulatory.bin
d7e558216ebe4d5ad01ccb0029c64456f740b9fd  2010.11.22-regulatory.bin
$ regdbdump ./2010.11.22-regulatory.bin
Database signature verification failed.

The old 2009.11.25-regulatory.bin works fine.
