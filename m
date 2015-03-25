Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailsrv5-bkp2.dondominio.net ([37.152.88.47]:33554 "EHLO
	mailsrv5.dondominio.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753311AbbCYPd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 11:33:28 -0400
Message-ID: <5512D58B.6030204@aoifes.com> (sfid-20150325_163331_181496_06C73F5E)
Date: Wed, 25 Mar 2015 16:34:35 +0100
From: Jose Antonio Delgado Alfonso <jose.delgado@aoifes.com>
MIME-Version: 1.0
To: kvalo@qca.qualcomm.com
CC: linux-wireless@vger.kernel.org,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: Dynamic channel Access
References: <CADxDmp50X2XnBjfk5qJKRH-n=1Cwagmjb_XyD+RJ4AgpPh-kjQ@mail.gmail.com> <CAEFj985wmiPwnF7rM1qCcO2K3X2yC_onO0AAMfm=9ytwpChzgg@mail.gmail.com> <etPan.542e8df5.6b8b4567.117@Okhwanui-Mac-mini.local> <55128DF0.6010109@aoifes.com>
In-Reply-To: <55128DF0.6010109@aoifes.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I would like to ask Qualcomm's collaborators about this topic.

We are trying to certify a AP product which uses QCA988x radio module.
We are using the ath10k driver (kernel v3.17.8) and firmware from Ben
Greear. We are trying to pass the Dynamic Channel test, which consists
in setting the radio at 80MHz and, at the same time, setting other
signal in the secondary channel. So far, the radio module does not
reduce the bandwidth and remains transmitting at 80MHz.

Please, Does someone know if Dynamic Channel Access is really supported
by ath10k driver in newest kernel versions?
Or, does it also depends on the firmware version?

Thanks in advance.

Regards,
Jose Delgado

