Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:10627 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYFFTh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2008 15:37:29 -0400
Received: by fg-out-1718.google.com with SMTP id 19so761058fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2008 12:37:27 -0700 (PDT)
To: Andrew Morton <akpm@linux-foundation.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Fri, 6 Jun 2008 21:37:22 +0200
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <20080606034738.9835782d.akpm@linux-foundation.org>
In-Reply-To: <20080606034738.9835782d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806062137.22994.Michal.Kudla@gmail.com> (sfid-20080606_213733_552883_8BA35B19)
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W li=C5=9Bcie datowanym na pi=C4=85tek, 6 czerwca 2008, Andrew Morton p=
isze:
>AM > [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
>AM
>AM Thanks.  Do you know if it worked in 2.6.24 or 2.6.25?

I checked:
- vanilla-sources-2.6.24.7 (works),
- gentoo-sources-2.6.25-r4 (don't work)

I uploaded files:
=2Econfig-2.6.23
=2Econfig.2.6.24.7
=2Econfig.2.6.25-gentoo-r4
=2Econfig-2.6.26
dmesg-2.6.23
dmesg-2.6.24.txt
dmesg-2.6.25.txt
dmesg-2.6.26
http://michal.kudla.googlepages.com/iwlwifi-problem-2.bz2

more infos about 2.6.25 anf iwlwifi:
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=3D1657=20
http://bugs.gentoo.org/show_bug.cgi?format=3Dmultiple&id=3D218565=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
