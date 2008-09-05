Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ro.mikronika.com.pl ([213.17.224.85]:11015 "EHLO
	cluster1.mikronika.com.pl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752489AbYIEIN6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 04:13:58 -0400
Message-ID: <48C0EA41.5050103@mikronika.com.pl> (sfid-20080905_101404_075249_D958DABB)
Date: Fri, 05 Sep 2008 10:13:53 +0200
From: Karol Szkudlarek <karol@mikronika.com.pl>
MIME-Version: 1.0
To: Zhu Yi <yi.zhu@intel.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: kernel crash during suspend using iwl3945 driver 1.2.26k	on	ubuntu
 hardy
References: <48BC47C5.2070807@mikronika.com.pl>	 <1220425598.28282.190.camel@debian.sh.intel.com>	 <loom.20080903T181136-957@post.gmane.org> <1220601300.28282.291.camel@debian.sh.intel.com>
In-Reply-To: <1220601300.28282.291.camel@debian.sh.intel.com>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Zhu Yi pisze:
> On Wed, 2008-09-03 at 18:22 +0000, Karol Szkudlarek wrote:
>  =20
>> Tests I performed with
>> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireles=
s-2.6.tar.bz2 which
>> is
>> compat-wireless-2008-08-06 and git-describe v2.6.26-rc9-14214-g9cb30=
10
>> and compat-wireless-2008-07-25 and git-describe
>> v2.6.26-rc9-14207-ga520bdb
>> with the same result...
>>    =20
>
> Please see if 2.6.27-rc kernels fix this problem. The wme_qdisc stuff=
 is
> removed in .27.
>
> Thanks,
> -yi
>  =20
Hello Zhu!

It will be tough to see in 2.6.27-rc kernels beacuse I use Ubuntu 8.04 =
LTS
which uses 2.6.24 linux kernel. :-(

--=20
Karol Szkudlarek
Mikronika
ul. Wykopy 2/4
60-001 POZNA=C3=91
tel. +48 61 6655600
fax +48 61 6655602
e-mail karol@mikronika.com.pl

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
