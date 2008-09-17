Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from otrok.post.sk ([85.248.69.172]:39680 "EHLO otrok.post.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYIQGdy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 02:33:54 -0400
Message-ID: <48D0A63D.000001.24267@kamasutra> (sfid-20080917_083359_037211_DE03B31E)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=ISO-8859-2
From: Ineya Ineya <ineya@post.sk>
To: <yi.zhu@intel.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: Re: iwlagn/iwl4965 problems with WEP and rmmod
Date: 17 Sep 2008 08:39:57 +0200 (CEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I didn\'t try other kernels yet (I wanted to avoid that if possible).=0D
=0D
On some ubuntu forum I found, that people are often referring to:=0D
compat-wireless-2008-08-06.tar.bz2=0D
=0D
Using this version I was able to authenticate with my router using WEP.=
 So I can try to narrow it down by going closer to \'latest\' and see w=
hich version still works.=0D
=0D
Is there any specific option I could turn on to enable more logging or =
which would help to identify whether the problem is in compat-wireless?=
=0D
=0D
=0D
----------------------------------=0D
Od: Zhu Yi  =0D
Komu: Ineya Ineya  =0D
Poslan=E1: 17.09.2008 03:46 =0D
Predmet: Re: iwlagn/iwl4965 problems with WEP and rmmod=0D
=0D
> On Tue, 2008-09-16 at 22:32 +0200, Ineya Ineya wrote:=0D
> > I\\\'m using Debian Etc: 2.6.24-etchnhalf.1-amd64 #1 SMP kernel, =0D
> > =0D
> > and I downloaded compat-wireless-old-2008-09-15.tar.bz2 and=0D
> =0D
> Wonder if it is compat-wireless related. Do you have the problem in=0D
> wireless-testing kernel or vanilla?=0D
> =0D
> Thanks,=0D
> -yi=0D
> =0D
>=20


__________
http://www.tahaj.sk - Stiahnite si najnovsie verzie vasich oblubenych p=
rogramov


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
