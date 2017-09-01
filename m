Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47424 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752019AbdIAOcI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Sep 2017 10:32:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RT2870 failure in kernel 4.12.8
References: <b08798d4-21eb-6fda-3972-50bc1f4d0e9a@lwfinger.net>
        <20170831075514.GA12340@redhat.com>
        <26ef3184-a19e-1bb7-7aa4-4e8647210763@lwfinger.net>
        <20170901085738.GA18397@redhat.com>
Date: Fri, 01 Sep 2017 17:31:57 +0300
In-Reply-To: <20170901085738.GA18397@redhat.com> (Stanislaw Gruszka's message
        of "Fri, 1 Sep 2017 10:57:39 +0200")
Message-ID: <87y3pymqw2.fsf@purkki.adurom.net> (sfid-20170901_163211_642950_727F362A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Thu, Aug 31, 2017 at 10:33:28AM -0500, Larry Finger wrote:
>> Should the patch to wireless-drivers be annotated with a Stable reference so
>> that it is added to 4.12 and 4.13?
>
> According to Documentation/networking/netdev-FAQ.txt networking patches
> should not be marked cc:stable, instead a decent commit log should
> be written describing a bugfix. Which I believe it is done for
> this patch.

But that's for net and net-next trees, not for wireless trees. With
wireless patches we use "Cc: stable@..." references.

-- 
Kalle Valo
