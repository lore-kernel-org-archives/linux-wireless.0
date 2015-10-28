Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:35249 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbbJ1MrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 08:47:20 -0400
Received: by ykek133 with SMTP id k133so6083533yke.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2015 05:47:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201510281954.CJInakYj%fengguang.wu@intel.com>
References: <1446031474-29368-1-git-send-email-bartosz.markowski@tieto.com>
	<201510281954.CJInakYj%fengguang.wu@intel.com>
Date: Wed, 28 Oct 2015 13:47:19 +0100
Message-ID: <CACKGw+Fj+H8AuG7uqa7iswnsxJJ3w==Uby_2FNkY-7ehBayVJg@mail.gmail.com> (sfid-20151028_134723_232987_7DC64C8E)
Subject: Re: [PATCH] ath10k: add QCA9377 chipset support
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 October 2015 at 12:51, kbuild test robot <lkp@intel.com> wrote:
> Hi Bartosz,
>
> [auto build test WARNING on next-20151022 -- if it's inappropriate base, please suggest rules for selecting the more suitable base]
>
> url:    https://github.com/0day-ci/linux/commits/Bartosz-Markowski/ath10k-add-QCA9377-chipset-support/20151028-192708
> config: i386-randconfig-x004-201543 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
> http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
>
> All warnings (new ones prefixed by >>):
>
>    drivers/net/wireless/ath/ath10k/pci.c: In function 'ath10k_pci_probe':
>>> drivers/net/wireless/ath/ath10k/pci.c:3040:17: warning: 'pci_ps' may be used uninitialized in this function [-Wmaybe-uninitialized]
>      ar_pci->pci_ps = pci_ps;
>                     ^

I will send a v2 then :-)

Bartosz
