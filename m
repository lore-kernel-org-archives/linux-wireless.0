Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sandesh.cdotd.ernet.in ([196.1.105.47]:34209 "HELO
        sandesh.cdotd.ernet.in" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with SMTP id S1752196AbeB0Lmu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 06:42:50 -0500
From: "KAVITA MATHUR" <kavitam@cdot.in>
To: ath10k@lists.infradead.org, backports@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: fixed bit rate 9Mbps set as 24Mbps in g mode(legacy)
Date: Tue, 27 Feb 2018 14:19:49 +0530
Message-Id: <20180227083933.M59708@cdot.in> (sfid-20180227_124254_716709_0A64351A)
In-Reply-To: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
References: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain;
        charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have configured AP in g mode and tested legacy rates.All basic rates and supported
rates(1,2,5.5,11,6,9,12,18,24,36,48,54) are set except 9Mbps.

When fixed bit rate 9Mbps is set, it gets set as 24 Mbps. This issue has been observed
in backports-4.4.2-1 as well as latest git version of ath10k driver.


Is anybody aware of this issue? How can I fix this rate 9Mbps?


Thanks & Regards,
Kavita
