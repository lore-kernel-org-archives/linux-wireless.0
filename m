Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47318 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759770Ab2EJObm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 10:31:42 -0400
Received: by qcro28 with SMTP id o28so1147926qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 07:31:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG9cJmkDf6koV93NyOo2W8D7Y3G6tapQOucjW5M7FLPDnNhvKQ@mail.gmail.com>
References: <CAG9cJmkDf6koV93NyOo2W8D7Y3G6tapQOucjW5M7FLPDnNhvKQ@mail.gmail.com>
Date: Thu, 10 May 2012 22:31:41 +0800
Message-ID: <CAG9cJmnV9o3DnZ9XNqYsBi04S=xa_dOmM_ia_6J5iQSgLYL9wA@mail.gmail.com> (sfid-20120510_163154_547400_A59CCB8C)
Subject: Re: how to remove the b43
From: lina <lina.lastname@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 9:38 PM, lina <lina.lastname@gmail.com> wrote:
> Hi,
>
> The same question as I asked before (please see
> https://lkml.org/lkml/2012/1/6/155)
>
> I want to clear the
> b43-fwcutter-015
> broadcom-wl-*
> and all it related.

Here is what I have tried,

1] For the b43-fwcutter-015

rm /usr/local/bin/b43-fwcutter
rm /usr/local/man/man1/b43-fwcutter.1

rm -r b43-fwcutter-015

2] For the broadcom-wl-5.100.138/

rm -r /lib/firmware/b43

not sure whether it's purged completely or not.

Thanks again,
