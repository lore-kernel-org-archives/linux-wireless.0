Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754350AbcLVSsw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Dec 2016 13:48:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAO7Z3WKmEbJCN_=srxTVKXvtz84vHGi41RS+9T7fmkmhRB6nEw@mail.gmail.com>
References: <1481841044-4314-1-git-send-email-glansberry@gmail.com>
 <20161219223111.itu77g7wsqtj6cvs@rob-hp-laptop> <CAO7Z3WKmEbJCN_=srxTVKXvtz84vHGi41RS+9T7fmkmhRB6nEw@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 22 Dec 2016 12:48:27 -0600
Message-ID: <CAL_JsqL4TMDaMQZM3h5gRBEiAa7-ApUWj4GgS_BPG6qpoLxv6g@mail.gmail.com> (sfid-20161222_194917_372078_81B91103)
Subject: Re: [PATCH 1/3] NFC: trf7970a: add device tree option for 27MHz clock
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Greer <mgreer@animalcreek.com>,
        Justin Bronder <justin@kuvee.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2016 at 5:23 PM, Geoff Lansberry <geoff@kuvee.com> wrote:
> I can make that change, however, I worry that it may be a bit
> misleading, since there are only two supported clock frequencies, but
> a number like that to me implies that it could be set to any number
> you want.   I'm new at this, and so I'll go ahead and change it as you
> request, but I'd like to hear your thoughts on my concern.

Then the binding doc just needs to state what are the 2 valid frequencies.

Rob
