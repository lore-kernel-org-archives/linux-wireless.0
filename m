Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbdBXU5N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 15:57:13 -0500
MIME-Version: 1.0
In-Reply-To: <3B67FD13-A482-4BEF-B619-DD9AF9CC129F@holtmann.org>
References: <20170125222307.3044-1-robh@kernel.org> <3B67FD13-A482-4BEF-B619-DD9AF9CC129F@holtmann.org>
From: Rob Herring <robh@kernel.org>
Date: Fri, 24 Feb 2017 14:56:48 -0600
Message-ID: <CAL_JsqL1c9vU0R0m73UXi6wvPscqNT9ZAxX8FxhMmLFGMRAeVQ@mail.gmail.com> (sfid-20170224_215717_877587_1949601B)
Subject: Re: [PATCH] NFC: remove TI nfcwilink driver
To: Samuel Ortiz <sameo@linux.intel.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ilan Elias <ilane@ti.com>,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 25, 2017 at 11:54 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Rob,
>
>> It appears that TI WiLink devices including NFC (WL185x/WL189x) never
>> shipped. The only information I found were announcements in Feb
>> 2012 about the parts. There's been no activity on this driver besided
>> common changes since initially added in Jan 2012. There's also no in
>> users that instantiate the platform device (nor DT bindings).
>>
>> This is a first step in removing TI ST (shared transport) driver in
>> favor of extending the BT hci_ll driver to support WL183x chips.
>
> since the firmware files TINfcInit_* also never made it into the linux-firmware tree, I have no idea who is using this driver. I am actually fine with removing it since it would be easy enough to bring back based on hci_ll driver once there is hardware to test this on.

Ping. Someone going to pick up this patch?

Rob
