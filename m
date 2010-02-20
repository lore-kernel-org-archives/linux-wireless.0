Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39832 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab0BTCg1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 21:36:27 -0500
Received: by pwj8 with SMTP id 8so751604pwj.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 18:36:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266628662.5699.15.camel@mj>
References: <20100220000921.15525.55155.stgit@mj.roinet.com>
	<1266626230.25707.60.camel@mj> <1266628662.5699.15.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 19 Feb 2010 18:36:07 -0800
Message-ID: <43e72e891002191836w1088b744re09d67056614cc28@mail.gmail.com>
Subject: Re: [PATCH v3] compat: move debugfs_remove_recursive() to
	compat-2.6.27
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 19, 2010 at 5:17 PM, Pavel Roskin <proski@gnu.org> wrote:
> debugfs_remove_recursive() appeared in Linux 2.6.27, so it should be in
> compat-2.6.27, not in compat-2.6.26.  Don't compile it if
> CONFIG_DEBUG_FS is disabled.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Thanks applied.

  Luis
