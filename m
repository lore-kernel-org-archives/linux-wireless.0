Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D4D9C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 069AA2085A
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:13:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfCNON2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:13:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55582 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbfCNON1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 10:13:27 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BACE7C0B6172;
        Thu, 14 Mar 2019 14:13:27 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 513585D784;
        Thu, 14 Mar 2019 14:13:27 +0000 (UTC)
Date:   Thu, 14 Mar 2019 15:13:25 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
Message-ID: <20190314141324.GB15786@redhat.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
 <20190313091252.GB2663@redhat.com>
 <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com>
 <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
 <20190313140607.GE2003@redhat.com>
 <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
 <20190313155028.GB5302@redhat.com>
 <CAKR_QV+=i_Sp26zCkTC9cAHrhVLq4w0FoxLVmD-T3wFyd-ruEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QV+=i_Sp26zCkTC9cAHrhVLq4w0FoxLVmD-T3wFyd-ruEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 14 Mar 2019 14:13:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Mar 14, 2019 at 03:02:14PM +0100, Tom Psyborg wrote:
> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> >
> > There should be no difference between enabling MFP with nohwcrypt and
> > without nohwcrypt,
> 
> well there is.

Perhaps then you could provide explanation why there is difference ?

> do you still want me to resend this with MFP enabled
> unconditionally for all chips?

Yes, but first lets clarify things.

Stanislaw
