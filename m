Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4412 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbYF1PWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 11:22:07 -0400
Date: Sat, 28 Jun 2008 11:10:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: George Fong <george@lateralplains.com>,
	linux-wireless@vger.kernel.org, mcgrof@gmail.com
Subject: Re: Problem making compat-wireless-2.6
Message-ID: <20080628151056.GA6110@tuxdriver.com> (sfid-20080628_172212_992687_AED3FBD6)
References: <200806281953.16371.george@lateralplains.com> <69e28c910806280421t5e0de8edm8d6aab9cd582ccb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910806280421t5e0de8edm8d6aab9cd582ccb7@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 28, 2008 at 01:21:54PM +0200, Stefanik G=E1bor wrote:

> Try editing drivers/net/wireless/b43/rfkill.c, and replacing
> RFKILL_STATE_UNBLOCKED with RFKILL_STATE_ON and
> RFKILL_STATE_SOFT_BLOCKED with RFKILL_STATE_OFF. Looks like rfkill is
> not part of the compat package, and no work has been done to match
> compat-wireless to older RFKILLs.

=46WIW, rfkill probably _should_ be in compat-wireless.  Luis?

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
