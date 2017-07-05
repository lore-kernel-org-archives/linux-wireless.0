Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:33832 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751653AbdGEObc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 10:31:32 -0400
Received: by mail-oi0-f43.google.com with SMTP id l130so127693813oib.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jul 2017 07:31:32 -0700 (PDT)
Subject: Re: [PATCH v2] rtlwifi: Fix memory leak when firmware request fails
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: linux-wireless@vger.kernel.org
References: <20170705142506.GA13562@symbol-HP-ZBook-15>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a54596fb-de82-2120-8b5a-4399c8e5d906@lwfinger.net> (sfid-20170705_163137_415269_A2B1E897)
Date: Wed, 5 Jul 2017 09:31:30 -0500
MIME-Version: 1.0
In-Reply-To: <20170705142506.GA13562@symbol-HP-ZBook-15>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/05/2017 09:25 AM, Souptick Joarder wrote:
> This patch will fix memory leak when firmware request fails
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
