Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:33004 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbZCFPv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 10:51:29 -0500
Message-ID: <49B1467E.7060004@openwrt.org> (sfid-20090306_165144_477901_C2D42FFB)
Date: Fri, 06 Mar 2009 16:51:26 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] [PATCH v2 0/3] ath9k: version checking macro cleanup
 (was [RFC] ath9k: use correct init values for ar9100 devices)
References: <1236326933-27412-1-git-send-email-juhosg@openwrt.org> <18865.3067.157807.500800@gargle.gargle.HOWL>
In-Reply-To: <18865.3067.157807.500800@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith =EDrta:
> Gabor Juhos wrote:
>> According to Luis request, here is the new patch-set with detailed=20
>> explanations.
>>
>> Changes since v1:
>>   * rebased against master-2009-03-04 of wireless-testing=20
>>
>=20
> Tested on AR5416, works fine.

Thank you! Works on AR9130 and on AR9132 as well.

Gabor

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
