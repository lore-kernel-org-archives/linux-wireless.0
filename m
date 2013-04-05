Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:52083 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab3DEJu5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 05:50:57 -0400
Message-ID: <515E9E6F.7050301@openwrt.org> (sfid-20130405_115100_667879_F1B9BB72)
Date: Fri, 05 Apr 2013 11:50:39 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH 0/6] rt2x00: use rt2x00mmio prefix for rt2x00mmio module
 functions
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org> <CAGXE3d9WHgXbKZc+Qp0anx9sA+inEg2k+aUbb=_rN_OsZfeDSA@mail.gmail.com>
In-Reply-To: <CAGXE3d9WHgXbKZc+Qp0anx9sA+inEg2k+aUbb=_rN_OsZfeDSA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.04.05. 10:16 keltezéssel, Helmut Schaa írta:
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

Thanks!

-Gabor
