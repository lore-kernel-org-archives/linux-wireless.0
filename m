Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35182 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751106AbeC2I7h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 04:59:37 -0400
Message-ID: <1522313973.5932.4.camel@sipsolutions.net> (sfid-20180329_105940_522737_9F76BE3D)
Subject: Re: [PATCH v3 2/3] mac80211: limit wmm params to comply with ETSI
 requirements
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Peter Oh <peter.oh@bowerswilkins.com>,
        Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Mar 2018 10:59:33 +0200
In-Reply-To: <5ABCA9EB.3060808@broadcom.com> (sfid-20180329_105511_871245_35D32528)
References: <20180328102411.25677-1-luca@coelho.fi>
         <20180328102411.25677-3-luca@coelho.fi>
         <fc2a88ae-b908-028a-9e3b-1457404d2c06@bowerswilkins.com>
         <1522312501.5932.0.camel@sipsolutions.net> <5ABCA9EB.3060808@broadcom.com>
         (sfid-20180329_105511_871245_35D32528)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-03-29 at 10:55 +0200, Arend van Spriel wrote:
> 
> > No, the regulations say you have to use a long content window, hence
> 
> Guess you mean "contention window" :-p

Heh, yes.

> > limiting both min and max at the lower end (hence max_t).
> 
> Do you have any reference to the new ETSI requirements. I would like to 
> know their motivation for putting requirements on WMM parameters.

It's for LAA - i.e. LTE on 5 GHz.

http://www.etsi.org/deliver/etsi_en/301800_301899/301893/02.01.01_60/en_301893v020101p.pdf

See Table 7 and Table 8 and references to it.

johannes
