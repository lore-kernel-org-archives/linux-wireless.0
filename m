Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:38054 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162478Ab3DEVOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 17:14:53 -0400
Received: by mail-we0-f170.google.com with SMTP id z2so3244812wey.29
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 14:14:52 -0700 (PDT)
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org> <CAGXE3d9WHgXbKZc+Qp0anx9sA+inEg2k+aUbb=_rN_OsZfeDSA@mail.gmail.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <CAGXE3d9WHgXbKZc+Qp0anx9sA+inEg2k+aUbb=_rN_OsZfeDSA@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <5F6B3AA0-EB1B-4002-AB44-A61BDE6DE31D@gmail.com> (sfid-20130405_231457_959125_F1124257)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 0/6] rt2x00: use rt2x00mmio prefix for rt2x00mmio module functions
Date: Fri, 5 Apr 2013 23:14:49 +0200
To: Gabor Juhos <juhosg@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sent from my iPad

On 5 apr. 2013, at 10:16, Helmut Schaa <helmut.schaa@googlemail.com> wrote:

> On Fri, Apr 5, 2013 at 8:26 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
>> This series replaces the rt2x00pci prefix to
>> rt2x00mmio of the functions provided by the
>> rt2x00mmio module. This is a supplement of the
>> 'rt2x00: rt2x00pci: fix build error on Ralink
>> RT3x5x SoCs' patch.
> 
> Patch set looks good to me! Thanks a lot Gabor.
> 
> Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

Yep, looks good to me as well.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

for the whole series.

Note to John: you will have to pull the wireless tree into the wireless-next tree before you can apply this series there.

---
Gertjan