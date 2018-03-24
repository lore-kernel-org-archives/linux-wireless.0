Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36410 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751828AbeCXJZq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 05:25:46 -0400
Date: Sat, 24 Mar 2018 17:25:31 +0800
From: kbuild test robot <lkp@intel.com>
To: Nipun Gupta <nipun.gupta@nxp.com>
Cc: kbuild-all@01.org, robin.murphy@arm.com, hch@lst.de,
        linux@armlinux.org.uk, gregkh@linuxfoundation.org,
        m.szyprowski@samsung.com, bhelgaas@google.com, zajec5@gmail.com,
        andy.gross@linaro.org, david.brown@linaro.org,
        dan.j.williams@intel.com, vinod.koul@intel.com,
        thierry.reding@gmail.com, robh+dt@kernel.org,
        frowand.list@gmail.com, jarkko.sakkinen@linux.intel.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        johan@kernel.org, msuchanek@suse.de, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-soc@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pci@vger.kernel.org, bharat.bhushan@nxp.com,
        leoyang.li@nxp.com, Nipun Gupta <nipun.gupta@nxp.com>
Subject: Re: [PATCH v2 1/2] dma-mapping: move dma configuration to bus
 infrastructure
Message-ID: <201803241752.4rHu1vIG%fengguang.wu@intel.com> (sfid-20180324_102607_732005_8DCFF229)
References: <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
In-Reply-To: <1521615323-4752-1-git-send-email-nipun.gupta@nxp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Nipun,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.16-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Nipun-Gupta/dma-mapping-move-dma-configuration-to-bus-infrastructure/20180323-232307
config: score-spct6600_defconfig (attached as .config)
compiler: score-elf-gcc (GCC) 4.9.4
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=score 

All errors (new ones prefixed by >>):

   init/main.o: In function `try_to_run_init_process':
   main.c:(.text+0x40): relocation truncated to fit: R_SCORE_24 against `run_init_process'
   main.c:(.text+0x78): relocation truncated to fit: R_SCORE_24 against `.L36'
   init/main.o: In function `.L132':
   main.c:(.text+0x190): relocation truncated to fit: R_SCORE_24 against `.L129'
   main.c:(.text+0x200): relocation truncated to fit: R_SCORE_24 against `.L132'
   init/main.o: In function `loglevel':
   main.c:(.init.text+0xa4): relocation truncated to fit: R_SCORE_24 against `get_option'
   init/main.o: In function `.L15':
   main.c:(.init.text+0x110): relocation truncated to fit: R_SCORE_24 against `strcmp'
   main.c:(.init.text+0x124): relocation truncated to fit: R_SCORE_24 against `parameq'
   main.c:(.init.text+0x14c): relocation truncated to fit: R_SCORE_24 against `printk'
   init/main.o: In function `.L31':
   main.c:(.init.text+0x160): relocation truncated to fit: R_SCORE_24 against `strcmp'
   init/main.o: In function `.L21':
   main.c:(.init.text+0x170): relocation truncated to fit: R_SCORE_24 against `.L15'
   init/main.o: In function `initcall_blacklist':
   main.c:(.init.text+0x198): additional relocation overflows omitted from the output
   drivers/base/platform.o: In function `platform_dma_configure':
>> platform.c:(.text.platform_dma_configure+0x0): undefined reference to `dma_common_configure'

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--PNTmBPCT7hxwcZjr
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
QRLcinkAAA==

--PNTmBPCT7hxwcZjr--
