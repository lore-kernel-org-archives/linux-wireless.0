Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51442 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1F3UOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 16:14:15 -0400
Received: by iwn6 with SMTP id 6so2224645iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 13:14:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110629220110.15622.34326.stgit@mj.roinet.com>
References: <20110629220110.15622.34326.stgit@mj.roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 30 Jun 2011 15:13:55 -0500
Message-ID: <BANLkTi=hUuBknFoAZtHwGq4919r+MhEVrA@mail.gmail.com> (sfid-20110630_221421_543089_F8E9F68C)
Subject: Re: [PATCH] compat: define irq_set_probe() and irq_set_noprobe() only
 on Linux 2.6.25+
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 29, 2011 at 5:01 PM, Pavel Roskin <proski@gnu.org> wrote:
> Signed-off-by: Pavel Roskin <proski@gnu.org>
>
> set_irq_probe() and set_irq_probe() are missing on Linux 2.6.24, so the
> code won't compile.  compat-wireless doesn't need those functions.  Keep
> the functions for Linux 2.6.25 and newer for other compat packages.

Applied and pushed, after my siesta from Colombia, thanks!

  Luis
