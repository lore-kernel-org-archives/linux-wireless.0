Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdBXVxC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 16:53:02 -0500
MIME-Version: 1.0
In-Reply-To: <9E986B17-64EA-46E5-BEE3-76217E31B0D1@holtmann.org>
References: <20170125222307.3044-1-robh@kernel.org> <3B67FD13-A482-4BEF-B619-DD9AF9CC129F@holtmann.org>
 <CAL_JsqL1c9vU0R0m73UXi6wvPscqNT9ZAxX8FxhMmLFGMRAeVQ@mail.gmail.com> <9E986B17-64EA-46E5-BEE3-76217E31B0D1@holtmann.org>
From: Rob Herring <robh@kernel.org>
Date: Fri, 24 Feb 2017 15:52:37 -0600
Message-ID: <CAL_JsqKqGcZ-T01wbH+pCM+NYaET2v-FRPtk_Rafojq179KiFw@mail.gmail.com> (sfid-20170224_225324_843458_A7853791)
Subject: Re: [PATCH] NFC: remove TI nfcwilink driver
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ilan Elias <ilane@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 24, 2017 at 3:43 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Rob,
>
>>>> It appears that TI WiLink devices including NFC (WL185x/WL189x) never
>>>> shipped. The only information I found were announcements in Feb
>>>> 2012 about the parts. There's been no activity on this driver besided
>>>> common changes since initially added in Jan 2012. There's also no in
>>>> users that instantiate the platform device (nor DT bindings).
>>>>
>>>> This is a first step in removing TI ST (shared transport) driver in
>>>> favor of extending the BT hci_ll driver to support WL183x chips.
>>>
>>> since the firmware files TINfcInit_* also never made it into the linux-firmware tree, I have no idea who is using this driver. I am actually fine with removing it since it would be easy enough to bring back based on hci_ll driver once there is hardware to test this on.
>>
>> Ping. Someone going to pick up this patch?
>
> if Samuel does not have anything pending for his tree, I can take it through bluetooth-next tree.

>From the looks of -next, it doesn't appear so.

Rob
