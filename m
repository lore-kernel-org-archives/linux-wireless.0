Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27504 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdEUUHn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 May 2017 16:07:43 -0400
From: Maya Haim <merez@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        qca_merez <qca_merez@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        wil6210 <wil6210@qca.qualcomm.com>,
        qca_liord <qca_liord@qca.qualcomm.com>
Subject: RE: [PATCH v2 4/5] wil6210: add option to ignore OTA regulatory hints
Date: Sun, 21 May 2017 20:07:32 +0000
Message-ID: <71d0595982f24c12b519fa67ea6f0ad8@euamsexm01a.eu.qualcomm.com> (sfid-20170521_220747_319519_EC61FDF5)
References: <1494848759-3651-1-git-send-email-qca_merez@qca.qualcomm.com>
        <1494848759-3651-5-git-send-email-qca_merez@qca.qualcomm.com>
 <8737c1a1h6.fsf@qca.qualcomm.com>
In-Reply-To: <8737c1a1h6.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kvalo@qca.qualcomm.com wrote:
>=20
> I wonder should something like this be in cfg80211? Because I doubt
> wil6210 is the only driver having this problem.

We will check that and share our conclusions.
Can you please drop this patch for now and apply the rest of the patches
(if there are no additional comments)?

>=20
> --
> Kalle Valo

Thanks,
Maya
