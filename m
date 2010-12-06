Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54755 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0LFS7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 13:59:19 -0500
Received: by iwn9 with SMTP id 9so535789iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 10:59:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
References: <jyQ21do2hOF.A.qwD.m_--MB@chimera>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Dec 2010 10:58:57 -0800
Message-ID: <AANLkTi=1s+BuSd42zzjkstbYFZUeMSn1zGMc13OgR6wG@mail.gmail.com>
Subject: Re: 2.6.37-rc4-git4: Reported regressions 2.6.35 -> 2.6.36
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are the 802.11 ones:

On Sun, Dec 5, 2010 at 12:15 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Unresolved regressions
> ----------------------
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=24022
> Subject         : wireless no longer works after 1st update of 10.10 [rtl819xE:ERR in init_firmware()]
> Submitter       : njin <marconifabio@ubuntu-it.org>
> Date            : 2010-11-29 19:49 (7 days old)


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=22842
> Subject         : iwl3945 suddenly stops working
> Submitter       : Felipe Contreras <felipe.contreras@gmail.com>
> Date            : 2010-11-14 11:14 (22 days old)
