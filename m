Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr710098.outbound.protection.outlook.com ([40.107.71.98]:24976
        "EHLO NAM05-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732280AbeGJSwD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 14:52:03 -0400
Date: Tue, 10 Jul 2018 11:51:38 -0700
From: Paul Burton <paul.burton@mips.com>
To: Boris Brezillon <boris.brezillon@bootlin.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 00/24] mtd: rawnand: Improve compile-test coverage
Message-ID: <20180710185138.mh564eehyfoaggsu@pburton-laptop> (sfid-20180710_205324_139183_12FADA9B)
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180709200945.30116-1-boris.brezillon@bootlin.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Boris,

On Mon, Jul 09, 2018 at 10:09:21PM +0200, Boris Brezillon wrote:
>   MIPS: txx9: Move the ndfc.h header to include/linux/platform_data/txx9
>   mtd: rawnand: txx9ndfmc: Allow selection of this driver when
>     COMPILE_TEST=y
>   MIPS: jz4740: Move jz4740_nand.h header to
>     include/linux/platform_data/jz4740
>   mtd: rawnand: jz4740: Allow selection of this driver when
>     COMPILE_TEST=y
>   mtd: rawnand: jz4780: Drop the dependency on MACH_JZ4780
>   memory: jz4780-nemc: Allow selection of this driver when
>     COMPILE_TEST=y
> 
>  arch/mips/jz4740/board-qi_lb60.c                   |  3 +-
>  arch/mips/txx9/generic/setup.c                     |  2 +-
>  arch/mips/txx9/generic/setup_tx4938.c              |  2 +-
>  arch/mips/txx9/generic/setup_tx4939.c              |  2 +-
>  drivers/memory/Kconfig                             |  6 ++--
>  drivers/mtd/nand/raw/Kconfig                       | 33 ++++++++++++++--------
>  drivers/mtd/nand/raw/jz4740_nand.c                 |  2 +-
>  drivers/mtd/nand/raw/txx9ndfmc.c                   |  2 +-
>  .../linux/platform_data/jz4740}/jz4740_nand.h      |  4 +--
>  .../linux/platform_data}/txx9/ndfmc.h              |  6 ++--
>  rename {arch/mips/include/asm/mach-jz4740 => include/linux/platform_data/jz4740}/jz4740_nand.h (91%)
>  rename {arch/mips/include/asm => include/linux/platform_data}/txx9/ndfmc.h (91%)

For the MIPS-related patches 19-24:

    Acked-by: Paul Burton <paul.burton@mips.com>

Thanks,
    Paul
