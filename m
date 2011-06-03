Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53382 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab1FCNp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 09:45:26 -0400
Received: by iyb14 with SMTP id 14so1391604iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 06:45:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1307108134.3800.1.camel@jlt3.sipsolutions.net>
References: <1307051170-17374-1-git-send-email-lauro.venancio@openbossa.org>
 <1307051170-17374-2-git-send-email-lauro.venancio@openbossa.org> <1307108134.3800.1.camel@jlt3.sipsolutions.net>
From: Aloisio Almeida <aloisio.almeida@openbossa.org>
Date: Fri, 3 Jun 2011 10:45:06 -0300
Message-ID: <BANLkTinJ8-i7z-nN1_UxwDX-rVD+jy85XA@mail.gmail.com> (sfid-20110603_154539_151108_C078B311)
Subject: Re: [PATCH 1/6] NFC: add nfc subsystem core
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, marcio.macedo@openbossa.org,
	sameo@linux.intel.com, Waldemar.Rymarkiewicz@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 3, 2011 at 10:35 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-06-02 at 18:46 -0300, Lauro Ramos Venancio wrote:
>
>> +struct nfc_dev *nfc_allocate_device(struct nfc_ops *ops,
>> +                                     u32 supported_protocols);
>
> Where do the protocols come from? I don't see any defines for them?

The defines are on the patch 2/6 (generic netlink): NFC_PROTO_*

Aloisio

>
> johannes
>
>
