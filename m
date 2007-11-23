Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.237]:20288 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXKWCEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2007 21:04:24 -0500
Received: by nz-out-0506.google.com with SMTP id s18so2393031nze
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2007 18:04:23 -0800 (PST)
Message-ID: <6995ca080711221804w7310134aw8a5902e45aa09942@mail.gmail.com> (sfid-20071123_020430_521558_587D061E)
Date: Thu, 22 Nov 2007 21:04:22 -0500
From: "Vadim Peretokin" <vperetokin@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Belin FD7010 v7
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1195781993.11966.27.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <6995ca080711221239t2947765ds765fd933fce5de31@mail.gmail.com>
	 <1195781993.11966.27.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ahh I'm afraid no, I'm not quite there yet and need my laptop
functional. But I'll let you know then when the next version of Ubuntu
comes about, thank you!

On Nov 22, 2007 8:39 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2007-11-22 at 15:39 -0500, Vadim Peretokin wrote:
>
> > But that is very ambiguous. Does that mean if anything is being done
> > to make this card work, do you know?
>
> The mac80211 driver for rtl8180/rtl8185 appeared in the "everything"
> branch of the wireless-2.6 repository just weeks ago.  If you are ready
> to recompile the kernel, use this to get the repository:
>
> git-clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
> cd wireless-2.6
> git-checkout --track -b everything remotes/origin/everything
>
> Make sure CONFIG_RTL8180 is enabled in .config file.
>
> --
> Regards,
> Pavel Roskin
>
>
