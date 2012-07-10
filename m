Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:38028 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2GJUiI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 16:38:08 -0400
Received: by weyx8 with SMTP id x8so331609wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 13:38:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120710133708.GC2260@redhat.com>
References: <1341834509-11601-1-git-send-email-sgruszka@redhat.com>
	<1341834647.4455.32.camel@jlt3.sipsolutions.net>
	<20120709115423.GE2438@redhat.com>
	<CANUX_P23xv5rXynEJHm=boR_g_7YqR1ROOQki6KGv+9LR9KEkg@mail.gmail.com>
	<20120710060211.GA2260@redhat.com>
	<CANUX_P3Vh1pqyK7TnNdYPS6nHpiUEzWDr4j8+8a5kXdhY3DrAA@mail.gmail.com>
	<20120710133708.GC2260@redhat.com>
Date: Tue, 10 Jul 2012 23:38:07 +0300
Message-ID: <CANUX_P2TV+F+CGdhR+UuXi_AFPb_ZD7LHO8s+kXisjou0dJJxw@mail.gmail.com> (sfid-20120710_223813_339760_35987655)
Subject: Re: [RHEL6 PATCH] iwlwifi: remove spurious warning
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>> On Tue, Jul 10, 2012 at 9:02 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > On Mon, Jul 09, 2012 at 10:10:38PM +0300, Emmanuel Grumbach wrote:
>> >> I would be glad to know on what commands this WARN_ON triggers
>> >> though... The command name should be printed along with the WARN_ON.
>> >
>> > REPLY_RX_PHY_CMD
>> >
>>
>> Ok thanks. This comes from the fw for every HT frame received in 4965.
>> Do you see that the WARNING triggers for every HT frame Rx?
>> I don't mind removing that code anyway, I was just asking to
>> understand what happens :-)
>
> I did not hit that. It was raported for iwl1000 on RHEL6.3:
> https://bugzilla.redhat.com/show_bug.cgi?id=837754
>

Ok, and the bug says - Occasional... Anyway.
