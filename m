Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39844 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755406AbdABNtO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 08:49:14 -0500
Message-ID: <1483364950.21014.4.camel@sipsolutions.net> (sfid-20170102_144919_602393_A76521A6)
Subject: Re: [PATCH V2 2/3] dt-bindings: document common IEEE 802.11
 frequency limit property
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Date: Mon, 02 Jan 2017 14:49:10 +0100
In-Reply-To: <20170102132747.3491-2-zajec5@gmail.com> (sfid-20170102_142833_051848_62BC2D8C)
References: <20170102132747.3491-1-zajec5@gmail.com>
         <20170102132747.3491-2-zajec5@gmail.com>
         (sfid-20170102_142833_051848_62BC2D8C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +pcie@0,0 {
> +	reg = <0x0000 0 0 0 0>;
> +	wifi@0,0 {
> +		reg = <0x0000 0 0 0 0>;
> +		ieee80211-freq-limit = <2402000 2432000>,
> +				       <2432000 2462000>;
> +	};
> +};

Syntactically, that might be a good example, but semantically it
doesn't really make sense to have those ranges that have a common
endpoint?

johannes
