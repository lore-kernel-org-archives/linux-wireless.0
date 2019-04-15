Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986E1C10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 12:10:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 700872075B
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 12:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfDOMKX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 08:10:23 -0400
Received: from webmail1.dei.unipd.it ([147.162.2.19]:33974 "HELO
        mail.dei.unipd.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with SMTP id S1726042AbfDOMKX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 08:10:23 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.dei.unipd.it (Postfix) with ESMTP id D887041B25;
        Mon, 15 Apr 2019 14:10:20 +0200 (CEST)
X-Virus-Scanned: amavisd-new at dei.unipd.it
Received: from mail.dei.unipd.it ([127.0.0.1])
        by localhost (mail.dei.unipd.it [127.0.0.1]) (amavisd-new, port 10024)
        with SMTP id ShRuxHIx-dVy; Mon, 15 Apr 2019 14:10:19 +0200 (CEST)
Received: from webmail1 (localhost.localdomain [127.0.0.1])
        by mail.dei.unipd.it (Postfix) with ESMTP id EA92D41B2C;
        Mon, 15 Apr 2019 14:10:19 +0200 (CEST)
Received: from pcrossi1.dei.unipd.it (pcrossi1.dei.unipd.it [147.162.97.9])
 by mail.dei.unipd.it (Horde Framework) with HTTPS; Mon, 15 Apr 2019 14:10:19
 +0200
Date:   Mon, 15 Apr 2019 14:10:19 +0200
Message-ID: <20190415141019.Horde.enqiXxoiTl-rjNpADtdMdyH@mail.dei.unipd.it>
From:   meneghello@dei.unipd.it
To:     s.gottschall@newmedia-net.de
Cc:     linux-wireless@vger.kernel.org
Subject: Re: wil6210 new features support
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Thank you.
Do you know if a new wil6210 firmware version is ready to be shared by  
Qualcomm?


On Wed, Apr 10, 2019 at 12:15 AM Sebastian Gottschall  
<s.gottschall@newmedia-net.de> wrote:

its constantly developed for latest chipset support. there is no  
direct versioning.

see https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/ for  
ongoing development on this driver (and others)

Am 05.04.2019 um 16:10 schrieb meneghello@dei.unipd.it:

Thank you for the answer.
However, is there the project to deliver a new version of wil6210  
driver in a short time?

Francesca Meneghello

On Sun, Mar 31, 2019 at 2:23 PM Sebastian Gottschall  
<s.gottschall@newmedia-net.de> wrote:

radar detection on a 60 ghz card?  there is no requirement for it. radar
is not operating at that frequencies

