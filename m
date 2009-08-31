Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42307 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZHaRZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 13:25:13 -0400
Received: by mail-ew0-f206.google.com with SMTP id 2so542184ewy.17
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 10:25:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A9BFCCB.6040808@ufra.edu.br>
References: <4A9BFCCB.6040808@ufra.edu.br>
Date: Mon, 31 Aug 2009 18:25:15 +0100
Message-ID: <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2009 at 5:39 PM, Leonardo H. Souza
Hamada<leonardo.hamada@ufra.edu.br> wrote:
> Hi list,
>
> On linux-2.6.24-gentoo-r3, the zd1211rw driver was working as eth1.
>
> This is a big-endian machine.
>
> On 2.6.30-gentoo-r5, 'ifconfig -a' shows the relevant entries below:

> Likely is a issue similar reported previously:
> http://marc.info/?l=linux-wireless&m=124906700820860&w=2
>
> Quick peek at the source diffs between previous version reveals some
> changes.

Are you talking about a regression - i.e. it used to work *on the same
architecture*, but not any more? If that's the case you can probably
start with 2.6.24 and various compat-wireless on to narrow down which
changes break.  The post you referred to is different - vendor driver
vs rw driver.
