Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52877 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab0KVBcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Nov 2010 20:32:23 -0500
Received: by iwn34 with SMTP id 34so2235890iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 21 Nov 2010 17:32:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1290389406-29852-1-git-send-email-lacombar@gmail.com>
References: <AANLkTi=BQckk2sXtR1VJ2khoK37YE=4t6k+wPb-CHhaw@mail.gmail.com>
	<1290389406-29852-1-git-send-email-lacombar@gmail.com>
Date: Sun, 21 Nov 2010 20:32:22 -0500
Message-ID: <AANLkTi=c-PgxN7XJLRqL4i8iiGeWPpe+6ryE+ybqKdsk@mail.gmail.com>
Subject: Re: [PATCH] compat/2.6.22: limit namespace pollution
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, Arnaud Lacombe <lacombar@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sun, Nov 21, 2010 at 8:30 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
> ---
>  include/linux/compat-2.6.22.h |   38 ++++++++++++++++++++++++++------------
>  1 files changed, 26 insertions(+), 12 deletions(-)
>
Please ignore the diffstat, I manually edited the patch to remove a
couple of nits.

A.
