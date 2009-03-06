Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:46418 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbZCFTjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 14:39:54 -0500
Message-ID: <49B17C4E.3000004@oracle.com> (sfid-20090306_203958_060245_E196467A)
Date: Fri, 06 Mar 2009 11:41:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: linux-next: Tree for March 6 (ath9k)
References: <20090306191311.697e7b97.sfr@canb.auug.org.au> <49B17320.8010000@oracle.com> <49B17B12.3050200@openwrt.org>
In-Reply-To: <49B17B12.3050200@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> Randy Dunlap =EDrta:
>> Stephen Rothwell wrote:
>>> Hi all,
>>>
>>> Linus' release of -rc7 seems to have stirred people up a bit ...
>>>
>>> Changes since 20090305:
>>
>> when CONFIG_RFKILL=3Dn, ath9k/virtual.c causes:
>>
>> (.text+0x224e83): undefined reference to `ath_radio_disable'
>> (.text+0x224e8b): undefined reference to `ath_radio_enable'
>>
>>
>=20
> Hi,
>=20
> I have submitted a patch for this already:
> http://marc.info/?l=3Dlinux-wireless&m=3D123633468314970&w=3D2
>=20
> Should I send it to somewhere else as well?

It hasn't propagated into the linux-next merging yet...


--=20
~Randy
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
