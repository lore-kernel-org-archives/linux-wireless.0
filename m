Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:55181 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbYCXXaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2008 19:30:03 -0400
Received: by py-out-1112.google.com with SMTP id u52so4539611pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2008 16:30:01 -0700 (PDT)
Message-ID: <43e72e890803241630n1906147ej1190d7562f5d1354@mail.gmail.com> (sfid-20080324_233036_492315_C0A128FB)
Date: Mon, 24 Mar 2008 19:30:00 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Florian Manschwetus" <florianmanschwetus@gmx.de>
Subject: Re: gentoo ebuild for compat wireless (resend)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47E839BE.5030806@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47E7A8DB.5020106@gmx.de>
	 <43e72e890803241304g13ea443co4e4afb1681da989c@mail.gmail.com>
	 <47E839BE.5030806@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 24, 2008 at 7:31 PM, Florian Manschwetus
<florianmanschwetus@gmx.de> wrote:
> Luis R. Rodriguez schrieb:
>
>
> > On Mon, Mar 24, 2008 at 9:12 AM, Florian Manschwetus
>  > <florianmanschwetus@gmx.de> wrote:
>  >> is it possible to get a version appendix on the tar.bz?
>  >>  so it should be easy to get a working ebuild fpr this.
>  >
>  > The problem is there's two things to "version", compat-wireless itself
>  > and Linux. I keep both version already as part of the tarball.
>  >
>  > wireless@sipsolutions:~$ cat compat-wireless-2.6/compat-release
>  > 2.8-49-gfe0f268
>  >
>  > wireless@sipsolutions:~$ cat compat-wireless-2.6/git-describe
>  > v2.6.25-rc5-2623-g7556b76
>  >
>  > You can also just pull these from the directory that was used to
>  > create the tarball:
>  >
>  > http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6/compat-release
>  > http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6/git-describe
>  >
>  > Does this suffice?
>
>
> Not really but it gives a version hint, could you create a symlink or so?
>  a url like that would be fine:
>  http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.8-49.tar.bz2

The problem is that does not reflect changes to Linux so there may be
a lot of great code added and yet this wouldn't reflect it. And if we
go with git-describe for Linux we could get updates on compat-wireless
itself during no code changes on Linux. I could use date (date -I),
that might work best but will it work for you?

  Luis
