Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:44702 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0ENQYD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 12:24:03 -0400
Received: by pvh1 with SMTP id 1so610807pvh.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 09:24:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BED77A2.7050105@dlasys.net>
References: <4BED77A2.7050105@dlasys.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 14 May 2010 09:23:41 -0700
Message-ID: <AANLkTilZF73IWzCILDxPLjkvK8HYFDRsyKDdcnyzqhG-@mail.gmail.com>
Subject: Re: compat-wireless
To: "David H. Lynch Jr." <dhlii@dlasys.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 14, 2010 at 9:17 AM, David H. Lynch Jr. <dhlii@dlasys.net> wrote:
>    I am working with the carl9170 driver.
>    I have a working development environment based on wireless-testing.
>
>    I am going to need to support carl9170 with older linux versions.
>    I pullled the compat-wireless git tree and can not figure out how to
> build from it.
>        Is there any step by step instructions to get from the raw git tree
> to being able to build against a specific kernel source ?
>
>    I DL'd the compat-wireless tarball for 2.6.32. I was able to get that
> working against ubuntu lucid kernel sources.
>    When I add the carl9170 driver I get a large collection of errors
> building it.
>            While some of these appear to be very specific to this driver
> many seem specific to differences between 2.6.32 compat-wireless and
> wireless testing. I was hoping moving to the compat-wireless git tree would
> fix that, but I can not figure out how to build from it.

compat-wireless uses linux-next as a source base tree, not
wireless-testing. Maybe that will help you.

>    In an altogether different project it would be useful use compat-wireless
> to support a newer wifi driver with a 2.6.27 kernel. That seems fairly
> standard. But I need to cross compile the kernel. As best as I can tell
> compat-wireless is setup  to work against your current running kernel. Are
> there any pointers for cross-compiling with compat-wireless, or for building
> against source other than that for the running kernel ?

Cross compilation is covered on the wiki pages for it, you modify KLIB
KLIB_BUILD.

  Luis
