Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:2848 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753000Ab1LVR51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 12:57:27 -0500
Message-ID: <4EF36E10.7070601@gmail.com> (sfid-20111222_185742_363820_F36C0AE6)
Date: Thu, 22 Dec 2011 18:51:12 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	users@rt2x00.serialmonkey.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [rt2x00-users] Poor performance and lockup with rt2800usb and
 Asus USB-N13 adapter
References: <4ED43A5C.9000102@gmail.com> <20111129114603.GB7299@redhat.com> <CADLC3L2QpEtPiBg+yvaxir1LpU6j5YMpDG4g0+ezs06g745zcg@mail.gmail.com> <20111220144317.GA6027@redhat.com> <20111222161810.GB13554@redhat.com> <201112221731.pBMHVScq005421@mail.maya.org>
In-Reply-To: <201112221731.pBMHVScq005421@mail.maya.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

On 12/22/11 18:31, Andreas Hartmann wrote:
>
> BTW: The patch in [1] breaks the driver completely (tested with
> compat-wireless 3.1rc1).
>
> [1]
> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-December/004345.html
>

I haven't reviewed these patches yet, but did you apply both patches 
that were sent out earlier today (which replace the one you mention here)?

Also, can you elaborate (preferably as a response to the actual patches) 
what exactly breaks with these patches? We need that kind of feedback to 
determine if we should apply these patches, as we (the maintainers) 
cannot always test and extensively review the patches in a short time.

---
Gertjan
