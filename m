Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:44650 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZCKRS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 13:18:29 -0400
Message-ID: <49B7F2B0.1000702@oracle.com> (sfid-20090311_181833_807174_AF10B7B7)
Date: Wed, 11 Mar 2009 10:19:44 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Gabor Juhos <juhosg@openwrt.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6 (ath9k)
References: <20090306191311.697e7b97.sfr@canb.auug.org.au> <49B17320.8010000@oracle.com> <49B17B12.3050200@openwrt.org> <49B17C4E.3000004@oracle.com> <20090306194045.GE3712@tuxdriver.com>
In-Reply-To: <20090306194045.GE3712@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Fri, Mar 06, 2009 at 11:41:02AM -0800, Randy Dunlap wrote:
>> Gabor Juhos wrote:
>>> Randy Dunlap =EDrta:
>>>> Stephen Rothwell wrote:
>>>>> Hi all,
>>>>>
>>>>> Linus' release of -rc7 seems to have stirred people up a bit ...
>>>>>
>>>>> Changes since 20090305:
>>>> when CONFIG_RFKILL=3Dn, ath9k/virtual.c causes:
>>>>
>>>> (.text+0x224e83): undefined reference to `ath_radio_disable'
>>>> (.text+0x224e8b): undefined reference to `ath_radio_enable'
>>>>
>>>>
>>> Hi,
>>>
>>> I have submitted a patch for this already:
>>> http://marc.info/?l=3Dlinux-wireless&m=3D123633468314970&w=3D2
>>>
>>> Should I send it to somewhere else as well?
>> It hasn't propagated into the linux-next merging yet...
>=20
> He just sent it today (or overnight).  I'll get it into wireless-next=
=2E
>=20
> John
>=20
> P.S.  I'm starting to think that RFKILL should just be mandatory...


This build error still happens in linux-next-20090311.

--=20
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
