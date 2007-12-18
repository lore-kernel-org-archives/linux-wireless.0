Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.231]:27969 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXLRTwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 14:52:34 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1359800nze.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2007 11:52:33 -0800 (PST)
Message-ID: <43e72e890712181152u1c543754j66ad1ed2acf7e344@mail.gmail.com> (sfid-20071218_195251_209769_272D1F4A)
Date: Tue, 18 Dec 2007 14:52:32 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Update cycle of compat-wireless-2.6
Cc: "Joachim Frieben" <jfrieben@freesurf.fr>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197996743.4885.178.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <62219.89.246.167.112.1197989446.squirrel@jose.freesurf.fr>
	 <1197996743.4885.178.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 18, 2007 11:52 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2007-12-18 at 15:50 +0100, Joachim Frieben wrote:
> > It appears that the content of
> > http://linuxwireless.org/download/compat-wireless-2.6 is still labeled
> > 2007-Dec-15 whereas on the download page
> > http://www.linuxwireless.org/en/users/Download
> > a daily update is announced. Any explanation for this discrepancy? ~jf
>
> It is updated daily, but if the compat patch fails to apply the old
> files stay around. I've just arranged for Luis to get mail if that
> happens so he can fix it.

I've updated comat/compat.diff which lets the patch apply and made a
few updates to the load/unload scripts. I've forced a regeneration of
the tarball. We're at v2.6.24-rc1-2799-gb8b5f6a. Feel free to download
and help test.

http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

  Luis
