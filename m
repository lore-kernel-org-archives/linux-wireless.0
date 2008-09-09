Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ro.mikronika.com.pl ([213.17.224.85]:4617 "EHLO
	cluster1.mikronika.com.pl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751606AbYIINiK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 09:38:10 -0400
Message-ID: <48C67C3A.5090806@mikronika.com.pl> (sfid-20080909_153814_801775_AAC89983)
Date: Tue, 09 Sep 2008 15:38:02 +0200
From: Karol Szkudlarek <karol@mikronika.com.pl>
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: kernel crash during suspend using iwl3945 driver 1.2.26k	on	ubuntu
 hardy
References: <48BC47C5.2070807@mikronika.com.pl>	 <1220425598.28282.190.camel@debian.sh.intel.com>	 <loom.20080903T181136-957@post.gmane.org> <1220601300.28282.291.camel@debian.sh.intel.com> <48C0EA41.5050103@mikronika.com.pl> <48C14AA2.1040202@lwfinger.net> <48C15A5E.6000301@canonical.com> <48C62D3C.8080907@mikronika.com.pl> <48C6696F.7070004@canonical.com>
In-Reply-To: <48C6696F.7070004@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Gardner pisze:
> Karol Szkudlarek wrote:
>> Tim Gardner pisze:
>>> Larry Finger wrote:
>>>> Karol Szkudlarek wrote:
>>>>> Hello Zhu!
>>>>>
>>>>> It will be tough to see in 2.6.27-rc kernels beacuse I use Ubuntu=
 8.04
>>>>> LTS
>>>>> which uses 2.6.24 linux kernel. :-(
>>>>>
>>>> The Ubuntu team has a 2.6.27 kernel available. To quote the text o=
f a
>>>> message in a BCM4306 thread "1)  If you are comfortable installing
>>>> packages on your own, the linux-image-2.6.27-* package is currentl=
y
>>>> available for you to install and test."
>>>>
>>>> Larry
>>>> --=20
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-wireless" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>> There is a Hardy package for the 2.6.27 kernel at
>>>
>>> http://ppa.launchpad.net/timg-tpi/ubuntu
>>>
>>> It is currently based on -rc5. I'll be updating it throughout the .=
27
>>> development and stable cycle.
>>>
>>> rtg
>> I would like try 2.6.27 so today I checked
>> http://ppa.launchpad.net/timg-tpi/ubuntu/dists/hardy/main/binary-i38=
6/Packages
>>
>> and I don't see any 2.6.27 packages...
>>
>> Second question: do you precompiled also all modules? I need them to
>> perform an upgrade and got the running system.
>>
>=20
> I found I could not have 2 packages with the same name but different
> versions in one PPA, so I moved the 2.6.27 package to the kernel team
> PPA at:
>=20
> http://ppa.launchpad.net/kernel-ppa/ubuntu
>=20
> Sorry for the confusion.
>=20
> rtg
>=20
OK. I downloaded the packages and during installation I got the=20
following error, please help me: :-)

# apt-get install linux-headers-2.6.27-3 linux-image-2.6.27-3-generic
Reading package lists... Done
Building dependency tree
Reading state information... Done
linux-headers-2.6.27-3 is already the newest version.
linux-image-2.6.27-3-generic is already the newest version.
0 upgraded, 0 newly installed, 0 to remove and 8 not upgraded.
1 not fully installed or removed.
After this operation, 0B of additional disk space will be used.
Setting up linux-image-2.6.27-3-generic (2.6.27-3.4) ...
Running depmod.
update-initramfs: Generating /boot/initrd.img-2.6.27-3-generic
cpio: not implemented or invalid option --

gzip: stdin: unexpected end of file
update-initramfs: failed for /boot/initrd.img-2.6.27-3-generic
=46ailed to create initrd image.
dpkg: error processing linux-image-2.6.27-3-generic (--configure):
  subprocess post-installation script returned error exit status 2
Errors were encountered while processing:
  linux-image-2.6.27-3-generic
E: Sub-process /usr/bin/dpkg returned an error code (1)


--=20
Karol Szkudlarek
Mikronika
ul. Wykopy 2/4
60-001 POZNA=D1
tel. +48 61 6655600
fax +48 61 6655602
e-mail karol@mikronika.com.pl
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
