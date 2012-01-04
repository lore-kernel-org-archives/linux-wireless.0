Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45382 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932118Ab2ADTGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 14:06:33 -0500
Received: by mail-lpp01m010-f51.google.com with SMTP id o2so5973705lag.10
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jan 2012 11:06:31 -0800 (PST)
Subject: Re: Git repo is failed.
From: Luciano Coelho <coelho@ti.com>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CALx5=V_XwYY-MOYBJtsYCLcLq2rnNEF161MAWyJcPWfjZYfEeA@mail.gmail.com>
References: <CALx5=V_XwYY-MOYBJtsYCLcLq2rnNEF161MAWyJcPWfjZYfEeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jan 2012 21:06:27 +0200
Message-ID: <1325703987.14403.65.camel@cumari> (sfid-20120104_200653_882099_6E3F69B2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-01-04 at 10:03 +0800, Matt Chen wrote: 
> Hi all,
> I am stuck on the http://linuxwireless.org/en/users/Download/hacking.
> It pointed out to create my own compat-wireless should require 3 repos.
> 1) git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> 2) git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git
> 3) git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6.git
> 
> Only 1) is working to me.
> 2) and 3) are failed. Can't clone. Anyone knows where to get them ?

2) git://git.infradead.org/users/mcgrof/compat.git or
   git://github.com/mcgrof/compat.git

3) git://git.infradead.org/users/mcgrof/compat-wireless.git or
   git://github.com/mcgrof/compat-wireless.git


-- 
Cheers,
Luca.

