Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:38852 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751339AbdAPO6u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jan 2017 09:58:50 -0500
Received: by mail-it0-f49.google.com with SMTP id c7so23002184itd.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2017 06:58:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201701150241.yCa5lXiT%fengguang.wu@intel.com>
References: <20170113111022.5570-1-ext.waldemar.rymarkiewicz@tieto.com> <201701150241.yCa5lXiT%fengguang.wu@intel.com>
From: Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
Date: Mon, 16 Jan 2017 15:58:24 +0100
Message-ID: <CAJ2u5D++qAhQZObmw_P_d8AsWWmi-v0AK+dRjo96j+gXgk2rVg@mail.gmail.com> (sfid-20170116_155855_265033_E2ECBE9A)
Subject: Re: [PATCH] ath10k: Search SMBIOS for OEM board file extension
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        ath10k@lists.infradead.org,
        Bartosz Markowski <bartosz.markowski@tieto.com>,
        "Chang, Robert" <rwchang@qti.qualcomm.com>,
        "Liu, Alan" <alanliu@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 January 2017 at 19:09, kbuild test robot <lkp@intel.com> wrote:
> Hi Waldemar,
>
> [auto build test WARNING on ath6kl/ath-next]
> [also build test WARNING on v4.10-rc3 next-20170113]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Waldemar-Rymarkiewicz/ath10k-Search-SMBIOS-for-OEM-board-file-extension/20170115-005232
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
> config: xtensa-allmodconfig (attached as .config)
> compiler: xtensa-linux-gcc (GCC) 4.9.0
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=xtensa
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net/wireless/ath/ath10k/core.c: In function 'ath10k_core_check_bdfext':
>>> drivers/net/wireless/ath/ath10k/core.c:754:2: warning: ignoring return value of 'strscpy', declared with attribute warn_unused_result [-Wunused-result]
>      strscpy(ar->id.bdf_ext, bdf_ext + strlen(magic),
>      ^

I will fix and send v2.

Thanks,
/Waldek
