Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52906 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752803AbeEUQ2d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 12:28:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Dreyfuss\, Haim" <haim.dreyfuss@intel.com>
Cc: Eric Biggers <ebiggers3@gmail.com>,
        linuxwifi <linuxwifi@intel.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho\, Luciano" <luciano.coelho@intel.com>
Subject: Re: [4.17 iwlwifi regression] NULL pointer dereference in reg_query_regdb_wmm()
References: <20180519183345.GA701@sol.localdomain>
        <409B2791E285FD41B488E034D9B4719F27E99C58@HASMSX106.ger.corp.intel.com>
Date: Mon, 21 May 2018 19:28:29 +0300
In-Reply-To: <409B2791E285FD41B488E034D9B4719F27E99C58@HASMSX106.ger.corp.intel.com>
        (Haim Dreyfuss's message of "Mon, 21 May 2018 10:10:09 +0000")
Message-ID: <87muwtezwy.fsf@kamboji.qca.qualcomm.com> (sfid-20180521_182836_927102_97C3439D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Dreyfuss, Haim" <haim.dreyfuss@intel.com> writes:

> Can you provide the following information?
> 1. The *boot* you mentioned is from clean shutdown or from Sx state?
> 2. Do you know which MCC the driver is trying to update?

You could also give some hints how to find the MCC and even tell what it
means. Is it Mobile Country Code or what?

-- 
Kalle Valo
