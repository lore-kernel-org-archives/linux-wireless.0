Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:16565 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYCXUEo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2008 16:04:44 -0400
Received: by el-out-1112.google.com with SMTP id v27so1410533ele.17
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2008 13:04:42 -0700 (PDT)
Message-ID: <43e72e890803241304g13ea443co4e4afb1681da989c@mail.gmail.com> (sfid-20080324_200448_274973_11753771)
Date: Mon, 24 Mar 2008 16:04:42 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Florian Manschwetus" <florianmanschwetus@gmx.de>
Subject: Re: gentoo ebuild for compat wireless (resend)
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47E7A8DB.5020106@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47E7A8DB.5020106@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 24, 2008 at 9:12 AM, Florian Manschwetus
<florianmanschwetus@gmx.de> wrote:
> is it possible to get a version appendix on the tar.bz?
>  so it should be easy to get a working ebuild fpr this.

The problem is there's two things to "version", compat-wireless itself
and Linux. I keep both version already as part of the tarball.

wireless@sipsolutions:~$ cat compat-wireless-2.6/compat-release
2.8-49-gfe0f268

wireless@sipsolutions:~$ cat compat-wireless-2.6/git-describe
v2.6.25-rc5-2623-g7556b76

You can also just pull these from the directory that was used to
create the tarball:

http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6/compat-release
http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6/git-describe

Does this suffice?

  Luis
