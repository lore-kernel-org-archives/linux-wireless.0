Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34363 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758125AbdACUVg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 15:21:36 -0500
MIME-Version: 1.0
In-Reply-To: <20170103195514.vf4psb6qw2bd2lcw@rob-hp-laptop>
References: <20161228155955.25518-1-zajec5@gmail.com> <20170103195514.vf4psb6qw2bd2lcw@rob-hp-laptop>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 3 Jan 2017 21:20:49 +0100
Message-ID: <CACna6rxmgN2zz-Fc1-Uu02oqMQreNkMJt0jGjLOMrXM=6iujFw@mail.gmail.com> (sfid-20170103_212146_237311_64A7B632)
Subject: Re: [PATCH 1/2] dt-bindings: document common IEEE 802.11 frequency properties
To: Rob Herring <robh@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 January 2017 at 20:55, Rob Herring <robh@kernel.org> wrote:
> On Wed, Dec 28, 2016 at 04:59:54PM +0100, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> This new file should be used for properties handled at higher level and
>> so usable with all drivers.
>
> Why is this needed? Where would this data normally come from?

Vendors limit choice of channels at their web user interface level. I
want to do better and report proper channels directly at kernel level
instead of masking them in every possible configuration tool.


>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>>  .../devicetree/bindings/net/wireless/ieee80211.txt       | 16 +++++++++=
+++++++
>>  1 file changed, 16 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/wireless/ieee8=
0211.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/ieee80211.tx=
t b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>> new file mode 100644
>> index 0000000..c762769
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/ieee80211.txt
>> @@ -0,0 +1,16 @@
>> +Common IEEE 802.11 properties
>> +
>> +This provides documentation of common properties that are handled by a =
proper
>> +net layer and don't require extra driver code.
>
> Not relavent to a binding. Bindings describe h/w.

Yes, Arend pointed it to me and I improved this Documentation file in
further versions. Could you review V4, please?
https://patchwork.kernel.org/patch/9494713/

--=20
Rafa=C5=82
