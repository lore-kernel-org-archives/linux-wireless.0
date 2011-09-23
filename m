Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58809 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1IWVyb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 17:54:31 -0400
Received: by qyk7 with SMTP id 7so4371632qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 14:54:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110923214805.10177.17141.stgit@mj>
References: <20110923214805.10177.17141.stgit@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 23 Sep 2011 14:54:11 -0700
Message-ID: <CAB=NE6X3wuv9SS0tC6oOddkP2ifCp8aD==9UF5er-681bJbb9g@mail.gmail.com> (sfid-20110923_235435_354866_12D2C033)
Subject: Re: [PATCH] compat: provide INIT_WORK with 2 arguments for kernels
 before 2.6.20
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 23, 2011 at 2:48 PM, Pavel Roskin <proski@gnu.org> wrote:
> Also provide work_func_t.  Originally implemented and tested in
> ndiswrapper.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Applied and pushed, thanks!

  Luis
