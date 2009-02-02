Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:37539 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452AbZBBSR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 13:17:59 -0500
Received: by gxk14 with SMTP id 14so1286338gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 10:17:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090130204452.GG3485@tuxdriver.com>
References: <20090130204452.GG3485@tuxdriver.com>
Date: Mon, 2 Feb 2009 10:17:58 -0800
Message-ID: <43e72e890902021017k34dd50cbj9132090ed112b1d0@mail.gmail.com> (sfid-20090202_191818_600565_897A02FA)
Subject: Re: wireless-regdb updated 2009-01-30
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 12:44 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> I have pushed an update to the wireless-regdb database here:
>
>        git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
>
> The changes include a new man page for regulatory.bin, some sample
> packages for .deb and .rpm generation, and an actual database change
> to correct a mistake in the Japan portion of the database.
>
> Enjoy!  Let me know if there are problems...

FYI this is now at:

http://wireless.kernel.org/download/wireless-regdb/wireless-regdb-2009.01.30.tar.bz2

The cron job was failing because compat-wireless  was failing, I've
moved the script to run before compat-wireless stuff. It should not
fail now hopefully.

  Luis
