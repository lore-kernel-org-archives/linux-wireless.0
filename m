Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35876 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbeAWTLN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 14:11:13 -0500
Message-ID: <1516734670.2508.40.camel@sipsolutions.net> (sfid-20180123_201232_039627_4598C15F)
Subject: Re: iwlegacy: Please change led_mode default to _LED_RF_STATE
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Luciano Coelho <luciano.coelho@intel.com>
Cc: cyp@abwesend.de, linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Tue, 23 Jan 2018 20:11:10 +0100
In-Reply-To: <20180123140733.GA4062@redhat.com> (sfid-20180123_150739_972713_56A7A232)
References: <CALY9mdzC06HRmPGF1q5G9Gz7Qc5miww8xuK-1rsGE37yMaQj1Q@mail.gmail.com>
         <1516713855.8658.18.camel@intel.com> <20180123140733.GA4062@redhat.com>
         (sfid-20180123_150739_972713_56A7A232)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-01-23 at 15:07 +0100, Stanislaw Gruszka wrote:
> 
> Some of iwlwifi devices have BLINK and some other have RF_STATE
> as default. I don't know why is that, but I assume there is reason
> for it. 

Not really. As I remember, the reason was basically marketing having
sold the devices with different defaults :-)

I for one have no objection to changing the default, but OTOH the OP
could just set a module configuration file and be done with it.

johannes
