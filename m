Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:37410 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753704AbeGFLxM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 07:53:12 -0400
Message-ID: <4398b64944ea3db28f6be049d55647eace271eb9.camel@intel.com> (sfid-20180706_135315_601356_3AAC0229)
Subject: Re: [linuxwifi] iwlwifi is not working after doing the reboot by
 pressing RESET button
From: Luciano Coelho <luciano.coelho@intel.com>
To: "Palanisamy, Rameshbabu" <Rameshbabu.Palanisamy@harman.com>,
        "linuxwifi@intel.com" <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 06 Jul 2018 14:53:09 +0300
In-Reply-To: <7b84c7c3393d4572b0a606cec5181e26@HIBDWSMB05.ad.harman.com>
References: <7b84c7c3393d4572b0a606cec5181e26@HIBDWSMB05.ad.harman.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HTML emails don't go through to the mailing lists at vger.kernel.org,
so please don't use HTML.

On Fri, 2018-07-06 at 08:40 +0000, Palanisamy, Rameshbabu wrote:
> Hi Team,
>  
>  
> I am using intel 8265 NGW wifi card in intel leafhill board.
>  
> We have enabled the Intel -wifi card in the Leaf_hill platform. After
> powering on the device, the wifi module is working fine but it
> doesn’t work when we do the reboot by pressing RESET button.
> We have debug the issue and found that  when we do the hard reboot by
> pressing the RESET key, the wifi module doesn’t detected.
> We have given the  lspci command before and after the hard reboot and
> the module is not listing in the lspci after hard reboot so we are
> suspecting that wifi module is not in the proper state due to the
> hard reboot.
> Could you please help to know what might be the issue.

This really sounds like a platform issue and not an iwlwifi/pci issue. 
For some reason your reset is leaving the NIC in a bad state.  Please
take it with whoever is providing this platform to you.

--
Cheers,
Luca.
