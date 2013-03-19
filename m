Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:35783 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab3CSNHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 09:07:07 -0400
Received: by mail-qe0-f43.google.com with SMTP id 1so236606qee.16
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2013 06:07:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com>
References: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com>
Date: Tue, 19 Mar 2013 07:07:05 -0600
Message-ID: <CAMLZHHTL40H7F2GBGn9F9EhuH4OhcptOBK0ocYXQi8GYQB=P6g@mail.gmail.com> (sfid-20130319_140711_845001_EF272A6A)
Subject: Re: mwifiex frequent "not allowed while suspended" crash on resume
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 19, 2013 at 12:43 AM, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Daniel,
>> mwifiex_sdio mmc0:0001:1: mwifiex_write_data_sync: not allowed while suspended
>> mwifiex_sdio mmc0:0001:1: host_to_card, write iomem (1) failed: -1
>
> This looks like the same issue with old XO platform where mmc gets timeout.
> Do you see "mmc0: Timeout waiting for hardware interrupt" message before mwifiex errors?

No. The messages I pasted are the first mwifiex messages produced on resume.

Daniel
