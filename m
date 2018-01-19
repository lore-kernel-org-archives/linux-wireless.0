Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41846 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbeASI2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 03:28:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mt76x2: init: disable tbtt tasklet during device cleanup
References: <cover.1516315624.git.lorenzo.bianconi@redhat.com>
        <f46c90a50429201056419aae168a836fcc406f47.1516315624.git.lorenzo.bianconi@redhat.com>
Date: Fri, 19 Jan 2018 10:28:18 +0200
In-Reply-To: <f46c90a50429201056419aae168a836fcc406f47.1516315624.git.lorenzo.bianconi@redhat.com>
        (Lorenzo Bianconi's message of "Fri, 19 Jan 2018 00:08:13 +0100")
Message-ID: <87607yxnfh.fsf@purkki.adurom.net> (sfid-20180119_092826_253545_7D59E271)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

No empty commit logs, please. At least the commit log should answer the
question "Why?". For example, are you fixing a reported bug or are you
fixing is a theoretical issue you found during code review? What kind of
symtomps does this bug have?

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_log_does_not_answer_why

-- 
Kalle Valo
