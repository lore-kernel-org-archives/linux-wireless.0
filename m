Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:51138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752661AbdAEQfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 11:35:09 -0500
MIME-Version: 1.0
In-Reply-To: <1483617089.4394.13.camel@sipsolutions.net>
References: <20170104175832.25996-1-zajec5@gmail.com> <CAL_JsqLg5YkC-YUHg6mQ35nmGaG7SC33VJB++fgtZsu1fRV-7Q@mail.gmail.com>
 <1483617089.4394.13.camel@sipsolutions.net>
From: Rob Herring <robh+dt@kernel.org>
Date: Thu, 5 Jan 2017 10:34:42 -0600
Message-ID: <CAL_JsqKYpTZFRJpPR1V9MmA-JW5ntoKzbkjwnYBp9HMWLObG3A@mail.gmail.com> (sfid-20170105_173513_116968_AE3BBBDA)
Subject: Re: [PATCH V6 1/3] dt-bindings: document common IEEE 802.11 frequency
 limit property
To: Johannes Berg <johannes@sipsolutions.net>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
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

On Thu, Jan 5, 2017 at 5:51 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> Acked-by: Rob Herring <robh@kernel.org>
>
> Do I take that to mean that we'll merge it through the subsystem tree,
> and not go through some common DT tree?

Yes, that's generally the case when bindings are in a series with
driver changes.

Rob
