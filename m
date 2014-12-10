Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:34194 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533AbaLJXzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 18:55:07 -0500
Received: by mail-la0-f46.google.com with SMTP id q1so3364867lam.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2014 15:55:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141205193039.GB53560@ubuntu-hedt>
References: <20141205193039.GB53560@ubuntu-hedt>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 10 Dec 2014 15:54:45 -0800
Message-ID: <CAB=NE6UXQK7GLEketAfuwYxWYX=gu5thZiDqHLfrbYjqsiu+xA@mail.gmail.com> (sfid-20141211_005522_506028_4F8B8173)
Subject: Re: [PATCH] crda: Trust regulatory.bin from Seth Forshee
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 5, 2014 at 11:30 AM, Seth Forshee
<seth.forshee@canonical.com> wrote:
> I have taken over maintenance of the regulatory database from
> linville. Add my key so that regulatory.bin files signed by me
> will be trusted, but also keep John's key so that existing files
> will continue to be trusted. Update the makefile to point to the
> new wireless-regdb repository location, and update the readme and
> man page to reflect the change in maintainership.
>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Applied and pushed, I'll bake a new release as soon as I can.

 Luis
