Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35425 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752698AbdADOUq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 09:20:46 -0500
Date: Wed, 4 Jan 2017 08:20:44 -0600
From: Rob Herring <robh@kernel.org>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH V5 4/3] brcmfmac: use wiphy_read_of_freq_limits to
 respect extra limits
Message-ID: <20170104142044.6xb3hndf7bjz5qcv@rob-hp-laptop> (sfid-20170104_152500_403181_077A5BD7)
References: <20170103225715.14072-1-zajec5@gmail.com>
 <20170103225715.14072-4-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20170103225715.14072-4-zajec5@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 03, 2017 at 11:57:15PM +0100, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> There are some devices (e.g. Netgear R8000 home router) with one chipset
> model used for different radios, some of them limited to subbands. NVRAM
> entries don't contain any extra info on such limitations and firmware
> reports full list of channels to us. We need to store extra limitation
> info on DT to support such devices properly.

This is the type of explanation that I'm looking for in the DT patch as 
well as the examples of where this data comes from now. Certainly, I 
think having per platform settings in userspace is not what you want.

Rob
