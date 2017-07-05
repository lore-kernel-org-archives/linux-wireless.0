Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:36655 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751727AbdGENvF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 09:51:05 -0400
Received: by mail-oi0-f52.google.com with SMTP id x187so68282924oig.3
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jul 2017 06:51:05 -0700 (PDT)
Subject: Re: [PATCH] rtlwifi: Fix memory leak when firmware request fails
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: linux-wireless@vger.kernel.org
References: <20170705060400.GA9481@symbol-HP-ZBook-15>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <5a7aa869-7942-1920-255a-1d8826bec8f6@lwfinger.net> (sfid-20170705_155109_404863_5558D3B7)
Date: Wed, 5 Jul 2017 08:51:02 -0500
MIME-Version: 1.0
In-Reply-To: <20170705060400.GA9481@symbol-HP-ZBook-15>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2017 01:04 AM, Souptick Joarder wrote:
> This patch will fix memory leak when firmware request fails
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

That is better, but how does Kalle know this is version two? That is covered in 
Documentation/process/submitting-patches.rst. Please read it.

NACK.

Larry
