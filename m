Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52303 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0LVUPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 15:15:05 -0500
Date: Wed, 22 Dec 2010 15:02:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] b43: Is this series still valid??
Message-ID: <20101222200215.GE10046@tuxdriver.com>
References: <1293045092-12483-1-git-send-email-linville@tuxdriver.com>
 <AANLkTikJcCWph2OCp+eaEsdKDXT8Q374KFp=13zX+Rro@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTikJcCWph2OCp+eaEsdKDXT8Q374KFp=13zX+Rro@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 08:20:18PM +0100, Rafał Miłecki wrote:
> 2010/12/22 John W. Linville <linville@tuxdriver.com>:
> > I found this old series pending in my queue from months ago.  I sat on
> > them because they had some discussion and never got reposted.
> >
> > Looking closer, the discussion never amounted to a NAK.  So, I tried
> > applying them, and they applied with only minor massaging.
> >
> > So, are these still valid?
> >
> > Let me know...
> 
> The way we call init in one of patches may be incorrect, I'm not sure
> if we still need to keep b_width (from other patch). I think it'll be
> better to ignore that patches for now.

OK, I'll drop them -- please repost if/when they are ready...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
