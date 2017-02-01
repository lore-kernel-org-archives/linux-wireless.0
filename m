Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39257 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750837AbdBAQdm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 11:33:42 -0500
Subject: Re: [PATCH v3] rt2x00: avoid introducing a USB dependency in the
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
References: <1485863050-24895-1-git-send-email-sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Vishal Thanki <vishalthanki@gmail.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <c8a64272-26b1-71d8-4557-9d38cbc83927@nbd.name> (sfid-20170201_173345_513452_0E2F1826)
Date: Wed, 1 Feb 2017 17:33:38 +0100
MIME-Version: 1.0
In-Reply-To: <1485863050-24895-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-31 12:44, Stanislaw Gruszka wrote:
> As reported by Felix:
> 
> Though protected by an ifdef, introducing an usb symbol dependency in
> the rt2x00lib module is a major inconvenience for distributions that
> package kernel modules split into individual packages.
> 
> Get rid of this unnecessary dependency by calling the usb related
> function from a more suitable place.
> 
> Cc: Vishal Thanki <vishalthanki@gmail.com>
> Reported-by: Felix Fietkau <nbd@nbd.name>
> Fixes: 8b4c0009313f ("rt2x00usb: Use usb anchor to manage URB")
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> v1 -> v2 do not break shutdown sequence
> v2 -> v3 update patch to current kernel version
What happened to the subject? It ends mid-sentence.

- Felix
