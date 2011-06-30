Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50714 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1F3UMT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 16:12:19 -0400
Received: by iwn6 with SMTP id 6so2223095iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 13:12:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110629204715.8477.90064.stgit@mj.roinet.com>
References: <20110629204715.8477.90064.stgit@mj.roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 30 Jun 2011 15:11:57 -0500
Message-ID: <BANLkTinaqdVvPXmgmwXghcvw7Otik7U0og@mail.gmail.com> (sfid-20110630_221224_641783_55B91B71)
Subject: Re: [PATCH] compat: use macro for netdev_name() to support Debian
 kernel 2.6.32-5
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 29, 2011 at 3:47 PM, Pavel Roskin <proski@gnu.org> wrote:
> Signed-off-by: Pavel Roskin <proski@gnu.org>
>
> Debian backports netdev_name as a function.  As we cannot test if a
> function is present, use an equivalent macro.
>
> Reported by Sivaraman V <krusna@gmail.com> and Alex <alex9434@gmail.com>

Thanks applied and pushed.

 LUis
