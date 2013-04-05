Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f178.google.com ([209.85.210.178]:61191 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3DEIQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:16:15 -0400
Received: by mail-ia0-f178.google.com with SMTP id r13so3034207iar.9
        for <linux-wireless@vger.kernel.org>; Fri, 05 Apr 2013 01:16:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
References: <1365143225-24532-1-git-send-email-juhosg@openwrt.org>
Date: Fri, 5 Apr 2013 10:16:13 +0200
Message-ID: <CAGXE3d9WHgXbKZc+Qp0anx9sA+inEg2k+aUbb=_rN_OsZfeDSA@mail.gmail.com> (sfid-20130405_101622_298847_66922BE4)
Subject: Re: [PATCH 0/6] rt2x00: use rt2x00mmio prefix for rt2x00mmio module functions
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 5, 2013 at 8:26 AM, Gabor Juhos <juhosg@openwrt.org> wrote:
> This series replaces the rt2x00pci prefix to
> rt2x00mmio of the functions provided by the
> rt2x00mmio module. This is a supplement of the
> 'rt2x00: rt2x00pci: fix build error on Ralink
> RT3x5x SoCs' patch.

Patch set looks good to me! Thanks a lot Gabor.

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>
