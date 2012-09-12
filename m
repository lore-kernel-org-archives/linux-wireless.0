Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:62854 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab2ILIPR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2012 04:15:17 -0400
Message-ID: <50504493.1060706@tieto.com> (sfid-20120912_101524_652355_97F754DF)
Date: Wed, 12 Sep 2012 10:15:15 +0200
From: Rymarkiewicz Waldemar <waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
To: Rymarkiewicz Waldemar <Waldemar.Rymarkiewicz@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"eric.lapuyade@linux.intel.com" <eric.lapuyade@linux.intel.com>
Subject: Re: [PATCH 1/3] NFC: Handle RSET in SHDLC_CONNECTING state
References: <1347437589-14450-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
In-Reply-To: <1347437589-14450-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On 09/12/2012 10:13 AM, Rymarkiewicz Waldemar wrote:
> As queue_work() does not guarantee ordered execution of sm_work it
> can happen in crossover RSET usecase that connect timer will constantly
> change the shdlc state from NEGOTIATING to CONNECTING before shdlc have
> chance to handle incoming frame.

Skip that one I will resend whole series.

Thanks,
/Waldek

