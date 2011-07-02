Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55763 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1GBQtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2011 12:49:23 -0400
Received: by iyb12 with SMTP id 12so3530334iyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jul 2011 09:49:22 -0700 (PDT)
Message-ID: <4E0F4C0E.5060306@lwfinger.net> (sfid-20110702_184927_223485_AF69C38A)
Date: Sat, 02 Jul 2011 11:49:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jon Mason <jdmason@kudzu.us>
CC: James Smart <james.smart@emulex.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Richard Lary <rlary@us.ibm.com>, wey-yi.w.guy@intel.com,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	chaoming_li@realsil.com.cn
Subject: Re: Warning: iwlegacy/iwlwifi/rtlwifi : removal of PCI_CAP_ID_EXP
References: <1309196346-15749-1-git-send-email-jdmason@kudzu.us>	<4E0CDF8B.3020505@emulex.com>	<294849c5-16f3-491b-98c2-2a96275e8378@exht1.ad.emulex.com> <BANLkTi=-43qKpbb6HdYuNTna__5cxVMfoA@mail.gmail.com>
In-Reply-To: <BANLkTi=-43qKpbb6HdYuNTna__5cxVMfoA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/01/2011 10:08 AM, Jon Mason wrote:
> pci_is_pcie checks for a PCI-E capability offset that was determined
> by calling pci_find_capability during the PCI bus walking.  Based on
> your description above this should be functionally equivalent.  If
> this is not safe, then the PCI bus walking code is most likely busted
> on EEH enabled PPC systems (and that is a BIG problem).

Are there PPC systems that support PCI-E cards? I looked for one earlier and did 
not find any. In particular, I wanted a machine to test the Realtek drivers for 
correct big-endian operation. I settled on a Powerbook G4 so that I could test 
the USB drivers.

Larry

