Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36987 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2GJNPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 09:15:11 -0400
Received: by wibhq12 with SMTP id hq12so3593813wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Jul 2012 06:15:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120710060211.GA2260@redhat.com>
References: <1341834509-11601-1-git-send-email-sgruszka@redhat.com>
	<1341834647.4455.32.camel@jlt3.sipsolutions.net>
	<20120709115423.GE2438@redhat.com>
	<CANUX_P23xv5rXynEJHm=boR_g_7YqR1ROOQki6KGv+9LR9KEkg@mail.gmail.com>
	<20120710060211.GA2260@redhat.com>
Date: Tue, 10 Jul 2012 16:15:09 +0300
Message-ID: <CANUX_P3Vh1pqyK7TnNdYPS6nHpiUEzWDr4j8+8a5kXdhY3DrAA@mail.gmail.com> (sfid-20120710_151531_858785_CFAF9641)
Subject: Re: [RHEL6 PATCH] iwlwifi: remove spurious warning
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach
egrumbach@gmail.com


On Tue, Jul 10, 2012 at 9:02 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Jul 09, 2012 at 10:10:38PM +0300, Emmanuel Grumbach wrote:
>> I would be glad to know on what commands this WARN_ON triggers
>> though... The command name should be printed along with the WARN_ON.
>
> REPLY_RX_PHY_CMD
>

Ok thanks. This comes from the fw for every HT frame received in 4965.
Do you see that the WARNING triggers for every HT frame Rx?
I don't mind removing that code anyway, I was just asking to
understand what happens :-)
