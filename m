Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mantis.wzyboy.im ([199.83.51.51]:39415 "EHLO mantis.wzyboy.im"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758458Ab3KMHZZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 02:25:25 -0500
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB301DFBCB5@HASMSX103.ger.corp.intel.com>
References: <CALkVjQb-Mg23YSqzwfN6bipadzTVm_aqzM4U_Bgu90=57UyOgg@mail.gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301DFBCB5@HASMSX103.ger.corp.intel.com>
From: wzyboy <wzyboy@wzyboy.org>
Date: Wed, 13 Nov 2013 15:25:08 +0800
Message-ID: <CALkVjQZ5wn5LsLcH=TaKrE6KdFSCMeFMr1_oFEAPCodVw5JWJA@mail.gmail.com> (sfid-20131113_082549_264379_C036B241)
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/11/13 Grumbach, Emmanuel <emmanuel.grumbach@intel.com>:
> It'll work on any kernel, including 3.11 you had before
>
> Sent from my phone.

Thanks Grumbach. I'm now in Linux 3.12 without your patch. The
"setpci" workaround still works!

-- 
wzyboy
