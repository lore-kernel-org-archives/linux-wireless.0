Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:53100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761952AbdADTrN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 14:47:13 -0500
MIME-Version: 1.0
In-Reply-To: <20170104175832.25996-1-zajec5@gmail.com>
References: <20170104175832.25996-1-zajec5@gmail.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Wed, 4 Jan 2017 13:46:46 -0600
Message-ID: <CAL_JsqLg5YkC-YUHg6mQ35nmGaG7SC33VJB++fgtZsu1fRV-7Q@mail.gmail.com> (sfid-20170104_204802_194080_5A1819D6)
Subject: Re: [PATCH V6 1/3] dt-bindings: document common IEEE 802.11 frequency
 limit property
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 4, 2017 at 11:58 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
>
> This new file should be used for properties that apply to all wireless
> devices.
>
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Switch to a single ieee80211-freq-limit property that allows specifying
>     *multiple* ranges. This resolves problem with more complex rules as pointed
>     by Felx.
>     Make description implementation agnostic as pointed by Arend.
>     Rename node to wifi as suggested by Martin.
> V3: Use more real-life frequencies in the example.
> V5: Describe hardware design as possible use for this property
> V6: Even better property description, thanks Rob for your help!
> ---
>  .../devicetree/bindings/net/wireless/ieee80211.txt | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee80211.txt

Acked-by: Rob Herring <robh@kernel.org>
