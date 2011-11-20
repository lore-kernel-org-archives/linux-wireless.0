Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ackle.nomi.cz ([81.31.33.35]:33689 "EHLO ackle.nomi.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab1KTDUU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Nov 2011 22:20:20 -0500
Date: Sun, 20 Nov 2011 04:20:16 +0100
From: =?utf-8?B?VG9tw6HFoSBKYW5vdcWhZWs=?= <tomi@nomi.cz>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: memory corruption with WPA enterprise
Message-ID: <20111120032016.GA14520@nomi.cz> (sfid-20111120_042041_631054_A2FA1349)
References: <20111110091816.GA2247@nomi.cz> <20111110114732.GA2217@redhat.com> <20111110125347.GA29415@nomi.cz> <20111110160703.GA2775@redhat.com> <20111110163051.GA24533@nomi.cz> <20111111054731.GA2292@redhat.com> <20111111150105.GA25437@nomi.cz> <20111114140714.GD2513@redhat.com> <20111119181106.GA5515@nomi.cz> <1321755233.22510.1.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1321755233.22510.1.camel@wwguy-ubuntu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, Nov 19, 2011 at 06:13:53PM -0800, wwguy wrote:
> hmm, I don't have any IOMMU supported system, I guess it is the time to
> get one :-)

Well, the bug manifests itself regardless of whether IOMMU is used or not...

Anyway, did you have time to try to reproduce it with the .config I sent?
(It may take hours, sometimes. :-/)

Regards,
-- 
Tomáš Janoušek, a.k.a. Liskni_si, http://work.lisk.in/
