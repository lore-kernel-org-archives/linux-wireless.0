Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:48050 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbZCFTfx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 14:35:53 -0500
Message-ID: <49B17B12.3050200@openwrt.org> (sfid-20090306_203556_070986_5C6B7EC5)
Date: Fri, 06 Mar 2009 20:35:46 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: Tree for March 6 (ath9k)
References: <20090306191311.697e7b97.sfr@canb.auug.org.au> <49B17320.8010000@oracle.com>
In-Reply-To: <49B17320.8010000@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap =EDrta:
> Stephen Rothwell wrote:
>> Hi all,
>>
>> Linus' release of -rc7 seems to have stirred people up a bit ...
>>
>> Changes since 20090305:
>=20
>=20
> when CONFIG_RFKILL=3Dn, ath9k/virtual.c causes:
>=20
> (.text+0x224e83): undefined reference to `ath_radio_disable'
> (.text+0x224e8b): undefined reference to `ath_radio_enable'
>=20
>=20

Hi,

I have submitted a patch for this already:
http://marc.info/?l=3Dlinux-wireless&m=3D123633468314970&w=3D2

Should I send it to somewhere else as well?

Gabor


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
